(ns app.main
  (:require [helix.core :refer [$]]
            [app.components :refer [app]]
            ["react-dom" :as rdom]
            ["./polyfill"]))

(defn init! []
  (set! js/document.body.style.margin "0")
  (rdom/render ($ app) js/document.body))
