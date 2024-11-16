(ns example.routes
  (:require [clojure.tools.logging :as log]
            [example.goodbye.routes :as goodbye-routes]
            [example.hello.routes :as hello-routes]
            [hiccup2.core :as hiccup]
            [reitit.ring :as reitit-ring]))

(defn routes
  [system]
  [""
   (hello-routes/routes system)
   (goodbye-routes/routes system)])

(defn not-found-handler
  [_request]
  {:status 404
   :headers {"Content-Type" "text/html"}
   :body (str
          (hiccup/html
           [:html
            [:body
             [:h1 "Not Found"]]]))})

(defn root-handler
  [system request]
  (log/info (str (:request-method request) " - " (:uri request)))
  (let [handler (reitit-ring/ring-handler
                 (reitit-ring/router
                  (routes system))
                 #'not-found-handler)]
    (handler request)))