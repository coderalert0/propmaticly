// Function to parse URL parameters into an object
function getUrlParams() {
    const params = {};
    const queryString = window.location.search.substring(1);
    const pairs = queryString.split('&');
    for (let i = 0; i < pairs.length; i++) {
        if (pairs[i] === '') continue;
        const pair = pairs[i].split('=');
        params[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || '');
    }
    return params;
}

// Get the parameters from the URL
const params = getUrlParams();

// Display the entity_name parameter in the appropriate span
if (params.entity_name) {
    document.getElementById('entity-name').textContent = params.entity_name;
} else {
    document.getElementById('entity-name').textContent = 'Not provided';
}

// Display the total_penalty parameter in the appropriate span
if (params.total_penalty) {
    document.getElementById('total-penalty').textContent = params.total_penalty;
} else {
    document.getElementById('total-penalty').textContent = 'Not provided';
}

// Show the penalty-info paragraph if both parameters are present
if (params.entity_name && params.total_penalty) {
    document.getElementById('penalty-info').style.display = 'block';
}