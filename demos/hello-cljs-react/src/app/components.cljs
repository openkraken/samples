(ns app.components
  (:require
   [helix.core :refer [defnc $]]
   [helix.dom :as d]
   [helix.hooks :as h]))

(defnc button [{:keys [on-click children]}]
  (d/button {:on-click on-click
             :style {:padding "8px 16px"
                     :background "#6180D2"
                     :color "#fff"
                     :border-radius "4px"}}
            children))

(defnc app []
  (let [[count set-count] (h/use-state 0)]
    (d/main
     {:style {:padding 20}}

     (d/h1 {:style {:color "#424242"}} "Hello Kraken!")

     (d/div
      {:style {:display "flex"
               :align-items "center"}}
      ($ button {:on-click #(set-count dec)} "-")
      (d/pre
       {:style {:margin "0 16px"
                :fontFamily "monospace"}}
       "count: " count)
      ($ button {:on-click #(set-count inc)} "+")))))
