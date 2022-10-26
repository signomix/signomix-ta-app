<widget_multimap>
<!--
    <div id={ref} class="card widget topspacing p-0">
        <div class="card-header h6 text-left p-1">{title}<span class="float-right">&#x2699;</span></div>
        <div class="card-body p-0 m-0" style={ heightStr } id={ref+'_m'}>
{ app.texts.widget_map.nodata[app.language] }
        </div>
    </div>
-->
    <div id={ref} class="container bg-white border border-info rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <div class="col-12 text-center {app.wt_color||'text-white'} sgx-wt"><span class="text-body">{isNotEmpty(title)?('&nbsp;'+title+'&nbsp;'):''}</span></div>
        </div>    
        <div class="row px-3 py-1">
                <div class="col-12"><div style={ heightStr } id={ ref+'_m' }>
{ app.texts.widget_map.nodata[app.language] }
        </div></div>
        </div>
    </div>
    <script>
    var self = this
    self.title = opts.title
    self.ref = opts.ref
    self.value = '-'
    self.measureDate = '-'
    self.front = true

    self.rawdata = "[]"
    self.jsonData = {}
    self.testGroup=
[
  [
    {
      "deviceEUI":"009FB2FF8EBB8E00",
      "name":"pm25",
      "value":4.4,
      "timestamp":1563222281230,
    },
    {
      "deviceEUI":"009FB2FF8EBB8E00",
      "name":"latitude",
      "value":11,
      "timestamp":1563222281230,
    }
  ],
  [
    {
      "deviceEUI":"52774790D697B9DD",
      "name":"pm25",
      "value":20.0,
      "timestamp":1563824861350
    },
    {
      "deviceEUI":"52774790D697B9DD",
      "name":"pm100",
      "value":55.0,
      "timestamp":1563824861350
    }
  ]
]

/*
[
  [
    [
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"latitude",
        "value":51.741808,
        "timestamp":1652425200123,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"longitude",
        "value":19.434113,
        "timestamp":1652425200123,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"temperature",
        "value":5.0,
        "timestamp":1652425200123,
        "stringValue":null
      }
    ],
    [
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"latitude",
        "value":51.741319,
        "timestamp":1652421600000,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"longitude",
        "value":19.425863,
        "timestamp":1652421600000,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"temperature",
        "value":4.0,
        "timestamp":1652421600000,
        "stringValue":null
      }
    ],
    [
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"latitude",
        "value":51.737721,
        "timestamp":1652418000000,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"longitude",
        "value":19.425207,
        "timestamp":1652418000000,
        "stringValue":null
      },
      {
        "deviceEUI":"IOT-EMULATOR",
        "name":"temperature",
        "value":3.0,
        "timestamp":1652418000000,
        "stringValue":null
      }
    ]
  ],
  [
    [
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"latitude",
        "value":51.735212,
        "timestamp":1652425200000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"longitude",
        "value":19.425521,
        "timestamp":1652425200000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"temperature",
        "value":5.0,
        "timestamp":1652425200000,
        "stringValue":null
      }
    ],
    [
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"latitude",
        "value":51.731331,
        "timestamp":1652421600000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"longitude",
        "value":19.425171,
        "timestamp":1652421600000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"temperature",
        "value":4.0,
        "timestamp":1652421600000,
        "stringValue":null
      }
    ],
    [
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"latitude",
        "value":51.731143,
        "timestamp":1652418000000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"longitude",
        "value":19.433445,
        "timestamp":1652418000000,
        "stringValue":null
      },
      {
        "deviceEUI":"S-18-0B-DB-36-7E",
        "name":"temperature",
        "value":3.0,
        "timestamp":1652418000000,
        "stringValue":null
      }
    ]
  ]
]

*/

    // map
    self.prevLat = 0.0
    self.prevLon = 0.0
    self.lat = 0.0
    self.lon = 0.0
    self.mapUrl = ''
    self.mapExternalUrl = ''
    self.noData = false
    self.alertLevel = 0
    self.range = ''
    self.rangeName
    
    self.heightStr='width:100%;height:100px;'
    var map;
    var markerList=[]
    var marker;
    
    
    this.on('mount',function(){
        app.log('MOUNTING MAP WIDGET')
        getWidth()
    })
    
    self.show2 = function(){
        app.log('SHOW2: widget_map')
        self.jsonData = JSON.parse(self.rawdata)
        app.log(self.jsonData)
        self.verify()
        self.showMap()
    }
    
    self.verify=function(){
        var minimalMeasures = 2
        var i=0
        var valuesOK=true
        var j
        var k
        //removing null values
        while(i<self.jsonData.length){
            //eui
            if(self.jsonData[i]==null || self.jsonData[i].length<1){
                //minimum 1 timestamp
                self.jsonData.splice(i,1)
            }else{
                valuesOK=true
                j=0
                k=0
                while(j<self.jsonData[i].length){
                    while(k<self.jsonData[i][j].length){
                      if(self.jsonData[i][j][k]===null){
                        self.jsonData[i][j][k]={'deviceEUI':null,'name':null,'value':null,'timestamp':null}
                      }
                      k=k+1
                    }
                    j=j+1
                }
                i=i+1
            }
        }
    }
    
    self.showMap = function(){
        if(self.jsonData.length==0 || self.jsonData[0].length<1){
            self.noData = true
            return
        }
        var calcAlert=(self.range!='' && self.range.indexOf('@')>0)
        if(calcAlert){
            self.rangeName=self.range.substring(self.range.indexOf('@')+1)
        }
        //markerList=[]
        riot.update()
        self.noData=false
        
        // Leaflet
        var zoom = 15;
        try{
            map = L.map(self.ref+'_m')
        }catch(err){
            app.log(err)
        }
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        
        for(var j=0; j<self.jsonData.length;j++){
            if(self.jsonData[j]==null){
                continue;
            }
            if(!markerList[j]){
                marker=new L.CircleMarker(self.getLatLon(self.jsonData[j][0]),{
                    radius: 12,
                    stroke: true,
                    color: 'black',
                    opacity: 1,
                    weight: 1,
                    fill: true,
                    fillColor: self.getMarkerColor(self.jsonData[j][0],calcAlert),
                    fillOpacity: 0.3
                })
                .bindPopup(self.getDescription(self.jsonData[j][0]),{closeButton:false})
                .addTo(map)
                markerList.push(marker)
            }else{
                markerList[j].setLatLng(self.getLatLon(self.jsonData[j][0]),{
                    radius: 12,
                    stroke: true,
                    color: 'black',
                    opacity: 1,
                    weight: 1,
                    fill: true,
                    fillColor: self.getMarkerColor(self.jsonData[j][0],calcAlert),
                    fillOpacity: 0.3
                })
                .setPopupContent(self.getDescription(self.jsonData[j][0]));
            }
        }
        //map.locate({setView: true, maxZoom: 12 });
        var fg = L.featureGroup(markerList);
        map.fitBounds(fg.getBounds());
        //
        riot.update()
    }
    
    self.getMarkerColor = function (point,calcAlert){
        result='green'
        if(!calcAlert){
            return result
        }
        for(var i=0;i<point.length;i++){
            if(point[i]){
                if(point[i].name==self.rangeName){
                    switch(getAlertLevel(self.range, point[i].value, point[i]['timestamp'])){
                        case 1:
                            result='yellow'
                            break
                        case 2:
                            result='red'
                            break
                        case 3:
                            result='grey'
                            break
                    }
                }
            }
        }
        return result
    }
    
    self.getLatLon = function (point){
        result=[0,0]
        var found=false
        for(var i=0;i<point.length;i++){
            if(point[i]){
                if(point[i].name=='latitude'){
                    result[0]=point[i].value
                    found=true
                }else if(point[i].name=='longitude'){
                    result[1]=point[i].value
                    found=true
                }
            }
        }
        if(found) return result
        for(var i=0;i<point.length;i++){
            if(point[i]){
                if(point[i].name=='lat'){
                    result[0]=point[i].value
                    found=true
                }else if(point[i].name=='lon'){
                    result[1]=point[i].value
                    found=true
                }
            }
        }
        if(found) return result
        result[0]=point[0]
        result[1]=point[1]        
        return result
    }
    
    self.getDescription = function(point){
        result = 'EUI: '+point[0]['deviceEUI']
        for(var i=0;i<point.length;i++){
            if(point[i]){
                result=result+'<br>'+point[i].name+': '+point[i].value
            }
        }
        if(point[i]){
            result=result+'<br>'+new Date(point[0].timestamp).toLocaleString(getSelectedLocale())
        }
        return result
    }
    
    this.on('update', function(e){
    })
    
    self.listener = riot.observable()
    self.listener.on('*',function(eventName){
        app.log("widget_a1 listener on event: "+eventName)
    })
    
    //$(window).on('resize', resize)
    
    function getWidth(){
        self.width=$('#'+self.ref).width()
        self.heightStr='width:100%;height:'+self.width+'px;'
    }
    
    function resize(){
        getWidth()
        self.show2()
    }
        
    </script>
    <style>
        .topspacing{
            margin-top: 10px;
        }
       
    </style>
</widget_multimap>