// Based On This : https://dribbble.com/shots/3751947-File-upload
// • CSS Daily Practice
// • June 14, 2018 
// • Day_10
// • Friends_Code_Challenge


jQuery(document).ready(function($){
    //$("#uploadForm").hide();
    var drop = $("input");
    drop
        .on("dragenter", function(e) {
        $(".drop").css({
          border: "4px dashed #09f",
          background: "rgba(0, 153, 255, .05)"
        });
        $(".cont").css({
          color: "#09f"
        });
        })
        .on("dragleave dragend mouseout drop", function(e) {
        $(".drop").css({
          border: "3px dashed #DADFE3",
          background: "transparent"
        });
        $(".cont").css({
          color: "#8E99A5"
        });
    });

    function handleFileSelect(evt) {
      var files = evt.target.files; // FileList object

      // Loop through the FileList and render image files as thumbnails.
      for (var i = 0, f; (f = files[i]); i++) {
        // Only process image files.
        if (!f.type.match("image.*")) {
          continue;
        }

        var reader = new FileReader();

        // Closure to capture the file information.
        reader.onload = (function(theFile) {
          return function(e) {
            // Render thumbnail.
            var span = document.createElement("span");
            console.log(e.target.result);
            console.log(theFile);
            span.innerHTML = [
              '<img class="thumb" src="',
              e.target.result,
              '" title="',
              escape(theFile.name),
              '" style="display: inline;"/>'
            ].join("");
            document.getElementById("list").insertBefore(span, null);
          };
        })(f);

        //$("#uploadForm").show();

        // Change container height to include images
        //console.log("Setting .cont height to 275px");
        //$(".drop").height = 275;
        //console.log($(".drop").height());

        // Read in the image file as a data URL.
        reader.readAsDataURL(f);
      }
    }

    $("#files").change(handleFileSelect);
});
