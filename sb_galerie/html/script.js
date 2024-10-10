window.addEventListener('message', function(event) {
    if (event.data.type === "showArtwork") {
        document.getElementById('artwork').src = event.data.url;
        document.getElementById('artwork-container').style.display = 'block';
    } else if (event.data.type === "hideArtwork") {
        document.getElementById('artwork-container').style.display = 'none';
    }
});

document.getElementById('close-button').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/closeArtwork`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => console.log(resp));
});

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeArtwork`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});