$("#micropost_image").bind("change", function() {
  var size_in_megabytes = this.files[0].size/500/400;
  if (size_in_megabytes > 5) {
      alert(I18n.t("shared.micropost_form.maximum_file_size_alert"));
    }
});
