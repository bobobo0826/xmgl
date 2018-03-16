import cache from './cache'
const getJson = async function (url, params) {
    let response = await tokenFetchAsync(url, params);
    let json = await response.json();
    return json;
}

const tokenFetchAsync = async function (url, params) {
    if (!params)
        params = {}
    let options = {
        method: params.method || 'POST',
        headers: {
            "Content-Type": "application/json",
            "token": cache.token,
            ...(params.headers || {})
        }
    }
    if (params.method != 'GET') {
        options['body'] = JSON.stringify((params.body || {}))
    }
    let response = await fetch(url, options);
    return response;
}

const fetchAsync = async function (url, params) {
    if (!params)
        params = {}
    let options = {
        method: params.method || 'POST',
        headers: {
            "Content-Type": "application/json",
            ...(params.headers || {})
        }
    }
    if (params.method != 'GET') {
        options['body'] = JSON.stringify((params.body || {}))
    }
    let response = await fetch(url, options);
    return response;
}

export { getJson, fetchAsync, tokenFetchAsync }