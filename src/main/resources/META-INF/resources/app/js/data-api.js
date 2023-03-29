/*
* Copyright (C) Grzegorz Skorupa 2018.
* Distributed under the MIT License (license terms are at http://opensource.org/licenses/MIT).
 */

function getFile(url, query, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus, ctype) {
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    oReq.onerror = function (oEvent) {
        app.log('ONERROR');
        app.requests--;
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            if (eventBus != null) try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.onloadend = function (oEvent) {
        app.log('ONLOADEND' + this.status);
        app.requests--;
        if (eventBus != null) {
            if (eventBus != null) try { eventBus.trigger("dataloaded"); } catch (err) { }
        }
        if (appEventBus != null) {
            appEventBus.trigger("dataloaded");
        }
    }
    oReq.onabort = function (oEvent) {
        app.log('ONABORT' + this.status);
        app.requests--;
        if (appEventBus == null) {
            if (eventBus != null) try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.timeout = function (oEvent) {
        app.log('ONTIMEOUT' + this.status);
        app.requests--;
        if (appEventBus == null) {
            if (eventBus != null) try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            if (this.status == 200) {
                if (callback != null) {
                    callback(oReq.response);
                } else {
                    if (eventBus != null) try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    if (eventBus != null) try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }
            }
        } else {
            app.log('READYSTATE=' + this.readyState);
        }
    };
    app.log('SENDING');
    app.requests++;
    oReq.responseType = 'blob'
    oReq.open("get", url, true);
    oReq.setRequestHeader("Accept", ctype);
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(query);
    //app.responses--;
    return false;
}

// get data from the service
function getData(url, query, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus, ctype, pcallback) {
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    if (pcallback) {
        oReq.addEventListener("progress", pcallback)
    }
    oReq.onerror = function (oEvent) {
        app.log('ONERROR');
        app.requests--;
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.onloadend = function (oEvent) {
        app.log('ONLOADEND' + this.status);
        app.requests--;
        if (eventBus != null) {
            eventBus.trigger("dataloaded");
        }
        if (appEventBus != null) {
            appEventBus.trigger("dataloaded");
        }
    }
    oReq.onabort = function (oEvent) {
        app.log('ONABORT' + this.status);
        app.requests--;
        if (appEventBus == null) {
            try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.timeout = function (oEvent) {
        app.log('ONTIMEOUT' + this.status);
        app.requests--;
        if (appEventBus == null) {
            try { eventBus.trigger("data:" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("data:" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            if (this.status == 200) {
                if (callback != null) {
                    if (ctype == null || ctype == '') {
                        callback(this.responseText, successEventName);
                    } else {
                        callback(oReq.response)
                    }
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }
            }
        } else {
            app.log('READYSTATE=' + this.readyState);
        }
    };
    app.log('SENDING');
    app.requests++;

    if (ctype) {
        oReq.responseType = 'blob'
        oReq.open("get", url, true);
        oReq.setRequestHeader("Accept", ctype);
    } else {
        oReq.open("get", url, true);
    }

    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(query);
    //app.responses--;
    return false;
}

async function fetchData(url, token) {
    try {
        let endpoint = serviceUrl + "/sdd/api/configurations/" + params.slug
        let headers = new Headers();
        headers.set('Authentication', token);
        const response = await fetch(url, { headers: headers })
        if (response.status == 200) {
            return response.json();
        } else if (response.status == 401 || response.status == 403) {
            //
        } else {
            //alert(
            //    utils.getMessage(utils.FETCH_STATUS)
            //.replace('%1', response.status)
            //        .replace('%2', response.statusText)
            //)
        }
    } catch (error) {
        console.log('ERROR')
        console.log(error)
    }
    return null
}

function sendFormData(oFormElement, method, url, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    app.log("sendFormData ...")
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            try { eventBus.trigger("auth" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("auth" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status == 200 || this.status == 201) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }

            }
        }
    }
    app.requests++;
    // method declared in the form is ignored
    oReq.open(method, url);
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(new FormData(oFormElement));
    return false;
}

function sendData(data, method, url, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    app.log("sendData ...")
    var urlEncodedData = "";
    var urlEncodedDataPairs = [];
    var name;
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    // Turn the data object into an array of URL-encoded key/value pairs.
    for (name in data) {
        urlEncodedDataPairs.push(encodeURIComponent(name) + '=' + encodeURIComponent(data[name]));
    }
    // Combine the pairs into a single string and replace all %-encoded spaces to 
    // the '+' character; matches the behaviour of browser form submissions.
    urlEncodedData = urlEncodedDataPairs.join('&').replace(/%20/g, '+');
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        callback(oEvent.toString());
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status > 199 && this.status < 203) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                app.log("onreadystatechange")
                if (errorEventName == null) {
                    try { eventBus.trigger(defaultErrorEventName + this.status); } catch (err) { }
                } else {
                    try { eventBus.trigger(errorEventName); } catch (err) { }
                }
            }
        }
    }
    app.requests++;
    // method declared in the form is ignored
    oReq.open(method, url);
    oReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(urlEncodedData);
    return false;
}

function sendIotData(data, method, url, eui, authKey, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    app.log("sendIotData ...")
    var urlEncodedData = "";
    var urlEncodedDataPairs = [];
    var name;
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    for (name in data) {
        urlEncodedDataPairs.push(encodeURIComponent(name) + '=' + encodeURIComponent(data[name]));
    }
    urlEncodedData = urlEncodedDataPairs.join('&').replace(/%20/g, '+');
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        callback(oEvent.toString());
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status > 199 && this.status < 203) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                app.log("onreadystatechange")
                if (errorEventName == null) {
                    try { eventBus.trigger(defaultErrorEventName + this.status); } catch (err) { }
                } else {
                    try { eventBus.trigger(errorEventName); } catch (err) { }
                }
            }
        }
    }
    app.requests++;
    oReq.open(method, url);
    oReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    oReq.setRequestHeader('X-device-eui', eui);
    if (authKey != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authorization", authKey);
    }
    oReq.send(urlEncodedData);
    return false;
}

function sendTextData(data, method, url, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    app.log("sendData ...")
    var urlEncodedData = "";
    var urlEncodedDataPairs = [];
    var name;
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        callback(oEvent.toString());
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status > 199 && this.status < 203) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                app.log("onreadystatechange")
                if (errorEventName == null) {
                    try { eventBus.trigger(defaultErrorEventName + this.status); } catch (err) { }
                } else {
                    try { eventBus.trigger(errorEventName); } catch (err) { }
                }
            }
        }
    }
    app.requests++;
    // method declared in the form is ignored
    oReq.open(method, url);
    oReq.setRequestHeader('Content-Type', 'text/plain');
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(data);
    return false;
}

function deleteData(url, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            try { eventBus.trigger("auth" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("auth" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status == 200) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }

            }
        }
    }
    app.requests++;
    oReq.open("DELETE", url, true);
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(null);
    return false;
}

function deleteConditional(data, url, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    var urlEncodedData = "";
    var urlEncodedDataPairs = [];
    var name;
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    for (name in data) {
        urlEncodedDataPairs.push(encodeURIComponent(name) + '=' + encodeURIComponent(data[name]));
    }
    urlEncodedData = urlEncodedDataPairs.join('&').replace(/%20/g, '+');
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            try { eventBus.trigger("auth" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("auth" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status == 200) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }

            }
        }
    }
    app.requests++;
    oReq.open("DELETE", url, true);
    oReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader("Authentication", token);
    }
    oReq.send(urlEncodedData);
    return false;
}

function sendJsonData(data, method, url, authHeader, token, callback, eventBus, successEventName, errorEventName, debug, appEventBus) {
    var oReq = new XMLHttpRequest();
    var defaultErrorEventName = "err:";
    oReq.onerror = function (oEvent) {
        app.log("onerror " + this.status + " " + oEvent.toString())
        if (appEventBus == null) {
            try { eventBus.trigger("auth" + this.status); } catch (err) { }
        } else {
            appEventBus.trigger("auth" + this.status);
        }
    }
    oReq.onreadystatechange = function () {
        if (this.readyState == 4) {
            app.requests--;
            if (this.status == 200 || this.status == 201) {
                app.log(JSON.parse(this.responseText));
                if (callback != null) {
                    callback(this.responseText);
                } else {
                    try { eventBus.trigger(successEventName); } catch (err) { }
                }
            } else {
                var tmpErrName
                if (errorEventName == null) {
                    tmpErrName = defaultErrorEventName + this.status
                } else {
                    tmpErrName = errorEventName
                }
                if (appEventBus == null) {
                    try { eventBus.trigger(tmpErrName); } catch (err) { }
                } else {
                    appEventBus.trigger(tmpErrName);
                }
            }
        }
    }
    app.requests++;
    oReq.open(method, url, true);
    if (token != null) {
        oReq.withCredentials = true;
        oReq.setRequestHeader(authHeader, token);
    }
    oReq.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    oReq.send(JSON.stringify(data));
    return false;
}