(defsystem "app"
  :class :package-inferred-system
  :depends-on ("app/app")

  :build-operation "program-op"
  :build-pathname "app"
  :entry-point "app/app::main")


#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c (eql (asdf:find-system "app"))))
  (uiop:dump-image (asdf:output-file o c)
                   :executable t
                   ;; to make a binary smaller
                   :compression t))


(asdf:register-system-packages "clack-handler-hunchentoot"
                               '("CLACK.HANDLER.HUNCHENTOOT"))
(asdf:register-system-packages "lack-request"
                               '("LACK.REQUEST"))
(asdf:register-system-packages "lack-response"
                               '("LACK.RESPONSE"))
(asdf:register-system-packages "log4cl"
                               '("LOG"))
