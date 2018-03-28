function clearFileInputField(Id) {
    document.getElementById(Id).value = "";
}
$(document).ready(function(){
    $("#checked_image").click(function(){
        $('#imgInp').click();
    });
    $("#imgInp").change(function () {
        var input_file = $(this);
        var form = input_file.closest("form");
        var data = form.serializefiles();
        $.ajax({
            type: "post",
            url: "/profile/update_ava",
            data       : data,
            processData: false,
            contentType: false,
            success: function (data) {
                clearFileInputField("imgInp");
                form.find("#userAva").attr("src", "data:image/png;base64," + data.base64)
                $("#user_avatar").val(data.base64);
            }
        });
    });
});