(uiop:define-package #:app/app
  (:use #:cl)
  (:import-from #:log)
  (:import-from #:ningle
                #:*response*
                #:*request*)
  (:import-from #:clack)
  (:import-from #:dexador)
  (:import-from #:clack.handler.hunchentoot)
  (:import-from #:alexandria
                #:appendf
                #:assoc-value)
  (:import-from #:babel
                #:octets-to-string)
  (:import-from #:lack.request
                #:request-content)
  (:import-from #:lack.response
                #:response-headers)
  (:import-from #:lack.response
                #:response-headers)
  (:import-from #:lack.request
                #:request-headers))
(in-package #:app/app)


(defvar *app* (make-instance 'ningle:app))


(setf (ningle:route *app* "/hello")
      "Hello from LISP microservice!")


(setf (ningle:route *app* "/handshake" :method :POST)
      (lambda (params)
        (declare (ignore params))
        
        (let* ((input (octets-to-string
                       (request-content *request*)
                       :encoding :utf-8))
               (handshake-content
                 (concatenate 'string
                              input
                              " Hello from LISP microservice!"))
               (handshake-url "http://host.docker.internal:8097/handshake"))
          (appendf (response-headers *response*)
                   (list :content-type "text/plain"))

          (let* ((response
                   (handler-case
                       (dex:post handshake-url
                                 :content handshake-content)
                     (error (e)
                       (setf (lack.response:response-status *response*) 500)
                       (format nil "Some error has happened when we tried to POST to \"~A\":~%~A"
                               handshake-url
                               e)))))
            response))))


(defun main (&key interface port use-thread (debug t))
  (clack:clackup *app*
                 :address (or interface
                              (uiop:getenv "INTERFACE")
                              "0.0.0.0")
                 :port (or port
                           (let ((env-port (uiop:getenv "PORT")))
                             (if env-port
                                 (parse-integer env-port)
                                 8096)))
                 :debug debug
                 :use-thread use-thread))
