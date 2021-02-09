var currentLang = "en";

function setCVLang(lang) {
    if (lang == "fr") {
        $("#cv_en").hide();
        $("#cv_fr").show();
    } else if (lang == "en") {
        $("#cv_en").show();
        $("#cv_fr").hide();
    }
}
function toggleCVLang(buttonSelector) {
    if (currentLang == "en") {
        currentLang = "fr";
        $(buttonSelector).text("Show CV in English");
    } else {
        currentLang = "en";
        $(buttonSelector).text("Show CV in French");
    }
    setCVLang(currentLang);
}

$(document).ready(() => {
    setCVLang("en");
});