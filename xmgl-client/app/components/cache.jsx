class Cache {

    token = sessionStorage.getItem('api_token')
    setAccessToken(token) {
        sessionStorage.setItem('api_token', token)
        this.token = token
    }
    getAccessToken() {
        return this.token || sessionStorage.setItem('api_token', token)
    }
    clearToken()
    {
        sessionStorage.removeItem('api_token')
    }
    setData(key,obj)
    {
        sessionStorage.setItem(key,JSON.stringify(obj))
    }
    getData(key)
    {
        return JSON.parse(sessionStorage.getItem(key))
    }
}
export default new Cache()