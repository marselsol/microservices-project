(ns com.example.core
  (:require [ring.adapter.jetty :as jetty]
            [compojure.core :refer [GET POST]]
            [compojure.route :as route]
            [ring.middleware.params :refer [wrap-params]]
            [clj-http.client :as client]))

(defn say-hello [request]
  {:status 200 :headers {"Content-Type" "text/plain"} :body "Hello from Clojure microservice!"})
	
(defn handshake [request]
  (let [body-slurped (slurp (:body request))
        url "http://host.docker.internal:8091/handshake"
        response (client/post url {:body (str body-slurped " Hello from Clojure microservice!")})]
    {:status 200 :headers {"Content-Type" "text/plain"} :body (:body response)}))

(def my-routes
  (compojure.core/routes
   (GET "/hello" [] say-hello)
   (POST "/handshake" [] handshake)
   (route/not-found "Not Found")))

(defn -main [& args]
  (jetty/run-jetty (wrap-params my-routes) {:port 8090}))