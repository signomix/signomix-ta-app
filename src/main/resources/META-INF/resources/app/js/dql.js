function applyFilter(query, filter){
    var result=sweepSpaces(query)
    if(filter.fromDate.length>0){
        result=replaceDQL(result,'from',filter.fromDate)
    }
    if(filter.toDate.length>0){
        result=replaceDQL(result,'to',filter.toDate)
    }
    if(filter.project.length>0){
        result=replaceDQL(result,'project',filter.project)
    }
    return result
}

function replaceDQL(query, key, value){
    var a=''
    var b=''
    var q2
    var idx1=query.indexOf(key)
    if(idx1<0){
        q2=query+' '+key+' '+value
    }else{
        a=query.substring(0,idx1)
        var idx2=query.indexOf(' ',idx1+(key+' ').length)
        if(idx2>0){
            b=query.substring(idx2)
        }
        q2=a+key+' '+value+b
    }
    return q2
}

function sweepSpaces(t){return t.trim().replace(/ +(?= )/g,'')}

function checkQuerySyntax(text){
    var dql=sweepSpaces(text)
    if(dql=='' || dql=='1' || dql=='last') return true
    var params=dql.split(' ')
    for(i=0; i<params.length;){
        switch(params[i]){
            case "last":
            case "average":
            case "minimum":
            case "maximum":
                if( params.length<(i+2) || !Number.isInteger(parseInt(params[i+1])) ){
                    return false
                }
                i=i+2;
                break;
            case "project":
            case "state":
            case "status":
            case "channel":
            case "group":
            case "new":
            case "from":
            case "to":
                if(params.length<i+2) return false
                i=i+2;
                break;
            case "timeseries":
            case "csv.timeseries":
            case "virtual":
                i=i+1;
                break;
            default:
                return false
        }
    }
    return true
}