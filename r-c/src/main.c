#include <microhttpd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <curl/curl.h>
#include <unistd.h>

#define PORT 8097

struct connection_info_struct {
    char *data;
    size_t data_size;
};

static size_t write_callback(void *ptr, size_t size, size_t nmemb, void *stream) {
    size_t real_size = size * nmemb;
    char *data = (char*)ptr;
    char temp[real_size + 1];
    strncpy(temp, data, real_size);
    temp[real_size] = '\0';
    strcat((char*)stream, temp);

    return real_size;
}

static int send_post_request(const char *data, char *response) {
    CURL *curl;
    CURLcode res;
    struct curl_slist *headers = NULL;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
        headers = curl_slist_append(headers, "Content-Type: text/plain");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_URL, "http://host.docker.internal:8098/handshake");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, (long)strlen(data));
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)response);

        printf("Data being sent: %s\n", data);
        fflush(stdout);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
            fflush(stderr);
            curl_slist_free_all(headers);
            curl_easy_cleanup(curl);
            curl_global_cleanup();
            return 1;
        }

        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return 0;
}

static int answer_to_connection(void *cls, struct MHD_Connection *connection,
                                const char *url, const char *method,
                                const char *version, const char *upload_data,
                                size_t *upload_data_size, void **con_cls) {
    if (strcmp(method, "POST") == 0 && strcmp(url, "/handshake") == 0) {
        if (*con_cls == NULL) {
            struct connection_info_struct *con_info;
            con_info = malloc(sizeof(struct connection_info_struct));
            if (con_info == NULL)
                return MHD_NO;
            con_info->data = NULL;
            con_info->data_size = 0;

            *con_cls = (void *)con_info;
            return MHD_YES;
        }

        if (*upload_data_size != 0) {
            struct connection_info_struct *con_info = *con_cls;
            con_info->data = realloc(con_info->data, con_info->data_size + *upload_data_size + 1);
            memcpy(&(con_info->data[con_info->data_size]), upload_data, *upload_data_size);
            con_info->data_size += *upload_data_size;
            con_info->data[con_info->data_size] = 0;
            *upload_data_size = 0;
            return MHD_YES;
        } else {
            struct connection_info_struct *con_info = *con_cls;

            printf("Input from client: %s\n", con_info->data);
            fflush(stdout);
            char response[8192] = {0};
            char request[8192];
            snprintf(request, sizeof(request), "%s Hello from C microservice!", con_info->data);

            send_post_request(request, response);

            struct MHD_Response *mhd_response = MHD_create_response_from_buffer(strlen(response),
                                                                               (void *)response, MHD_RESPMEM_MUST_COPY);

            MHD_add_response_header(mhd_response, "Content-Type", "text/plain");

            int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
            MHD_destroy_response(mhd_response);

            if (con_info->data)
                free(con_info->data);
            free(con_info);
            *con_cls = NULL;

            return ret;
        }
    } else if (strcmp(method, "GET") == 0 && strcmp(url, "/hello") == 0) {
        const char *response = "Hello from C microservice!";
        struct MHD_Response *mhd_response = MHD_create_response_from_buffer(strlen(response),
                                                                           (void *)response, MHD_RESPMEM_MUST_COPY);
        
        MHD_add_response_header(mhd_response, "Content-Type", "text/plain");

        int ret = MHD_queue_response(connection, MHD_HTTP_OK, mhd_response);
        MHD_destroy_response(mhd_response);
        return ret;
    }
    return MHD_NO;
}


int main() {
    struct MHD_Daemon *daemon;

    daemon = MHD_start_daemon(MHD_USE_INTERNAL_POLLING_THREAD, PORT, NULL, NULL,
                              &answer_to_connection, NULL, MHD_OPTION_END);
    if (NULL == daemon)
        return 1;

    printf("C microservice running on port %d\n", PORT);
    fflush(stdout);

    while (1) {
        sleep(5);
    }

    MHD_stop_daemon(daemon);
    return 0;
}