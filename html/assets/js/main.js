let n_mensaje = 0
let kills = 0

window.addEventListener('message', (event) => {
    if (event.data.action == "show") {
        displayHUD();
    } else if (event.data.action == "hide") {
        hideHUD();
    } else if (event.data.action === "kill"){
        insertarMensajeKill(event.data.name, event.data.money);
    } else if (event.data.action === "reset") {
        resetPurge();
    } else if (event.data.action === "eventStarted"){
        let mensaje_bienvenida = "<p id='welcome'>La purga acaba de comenzar, ¡mucha suerte!";
        let mensaje_bienvenida2 = "<p id='welcome2'>Recuerda, se puede matar por toda la ciudad puedes estar a salvo en zona segura<b>recompensa</b>.";
        $("#mensajes").prepend(mensaje_bienvenida);
        $("#mensajes").append(mensaje_bienvenida2);
        setTimeout(function () {
            $("#welcome").hide(1800);
            $("#welcome2").hide(1800);
        }, 8000)
    }
});

function insertarMensajeKill(nombre, dinero){
    n_mensaje = n_mensaje + 1;
    let mensaje = "<p id='"+n_mensaje+"'>💰 +<b>"+dinero+"</b>€ por matar a "+nombre+"</p>"
    $("#mensajes").prepend(mensaje);
    hideMessage(n_mensaje);
    kills=kills+1;
    $("#kill_count").html(kills);
}

function hideMessage(mensaje){
    setTimeout(function () {
        $("#"+mensaje).hide(2000);
    }, 3000)
}

function displayHUD(){
    $("body").show(1500);
    //var aud = document.getElementById("audio_purge");
    //aud.volume = 0.2;
    document.getElementById('audio_purge').load();
    document.getElementById('audio_purge').play();
    setTimeout(function () {
        document.getElementById('audio_purge').pause();
    }, 71000);
}

function hideHUD(){
    $("body").hide(1500);
}

function resetPurge(){
    console.log("Has hecho un total de "+kills+" kills");
    hideHUD();
    n_mensaje = 0;
    kills = 0;
    $("#kill_count").html(kills);
}