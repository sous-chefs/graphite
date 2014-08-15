graphite_web_config "/tmp/local_pie_settings.py" do
  config({
           blueberry: "pie_is_great",
           should_be: ["chocolate", true, 100],
           cakes: {
             chocolate: {
               calories: "a lot",
               flavor: "supersweet",
               frosting: ["some", 10, false]
             },
             coconut: {
               calories: false,
               flavor: "none",
               frosting: ["true", 1000, 1.01]
             }
           },
           pi: 3.141592653589793238462643383
         })
end
