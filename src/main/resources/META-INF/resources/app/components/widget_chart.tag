<widget_chart>
    <div id="{ref}" ref={ref} if="{type == 'line' || type == 'stepped'}" class="container-fluid bg-white border border-info rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <div class="col-12 text-center {app.wt_color||'text-white'} sgx-wt" onclick={ switchCard()}><span class="text-body">{title.length>0?('&nbsp;'+title+'&nbsp;'):''}</span></div>
        </div> 
        <div class="row px-3 py-1" if={ front }>
                <div class="col-12">
                    <canvas ref="line0" id="line0"></canvas>
                </div>
        </div>
        <div class="row px-3 py-1" if={ !front }>
            <div if={ ! dataAvailable} class="col-12">
                <p>{ app.texts.widget_chart.nodata[app.language] }</p>
            </div>
            <div if={dataAvailable} class="col-12 table-responsive">
            <table id="devices" class="table table-condensed">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">{ app.texts.widget_chart.timestamp[app.language] }</th>
                        <th scope="col" if="{!multiLine}"><span class="float-right">{ jsonData[0][0].name }</span></th>
                        <th scope="col" if="{multiLine}" each="{jsonData[0]}"><span class="float-right">{ name }</span></th>
                    </tr>
                </thead>
                <tbody if="{!multiLine}">
                    <tr each="{item,index in jsonData[0]}" class='small'>
                        <td>{ index }</td>
                        <td>{formatDate(new Date(item.timestamp), true)}</td>
                        <td><span class="float-right">{item.value}</span></td>
                    </tr>
                </tbody>
                <tbody if="{multiLine}">
                    <tr each="{item,index in jsonData}" class='small'>
                        <td>{ index }</td>
                        <td>{formatDate(new Date(item[0].timestamp), true)}</td>
                        <td each="{item}"><span class="float-right">{value}</span></td>
                    </tr>
                </tbody>
            </table>
            </div>
        </div>
    </div>
    <script>
        var self = this

        self.front = true
        self.rawdata = "[]"
        self.jsonData = []
        self.line = this.refs.line0
        self.ctxL = {}
        self.chart = {}
        self.width = 100
        self.heightStr = 'height:100px;'
        self.multiLine = false
        self.dataAvailable=false;

        self.show2 = function(){
            app.log(this.rawdata)
            self.jsonData = JSON.parse(this.rawdata)
            app.log(self.jsonData)
            if (self.jsonData.length == 0 || self.jsonData[0].length == 0){
                self.dataAvailable=false;
                return;
            }
            self.dataAvailable=true;
            getWidth()
            self.multiLine = self.jsonData[0].length > 1 && self.jsonData[0][1]['name'] != self.jsonData[0][0]['name']
            self.showMultiLineGraph(self.type,false,self.chartOption)
        }
        
        self.showMultiLineGraph = function(chartType,afterSwitch,chartOption){  
            if (!self.front || self.jsonData[0].length == 0 ){ 
                app.log('return because '+self.front+' '+self.jsonData[0].length)
                return 
            }
            self.line = this.refs.line0
            self.ctxL = self.line.getContext('2d')
            var minWidth = 400
            var largeSize = self.width > minWidth
            var numberOfLines = self.multiLine?self.jsonData[0].length:1
            var colors = [
                'rgb(54, 162, 235)',
                'rgb(75, 192, 192)',
                'rgb(255, 99, 132)',
                'rgb(255, 159, 64)'
            ]
            var areaColors = [
                'rgba(54, 162, 235, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(255, 99, 132, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ]
            var axesNames = ['yAxis1','yAxis2','yAxis3','yAxis4']
            
            var chartData = {
                labels: [],
                datasets: []
            }
            for(i=0; i<numberOfLines; i++){
                chartData.datasets.push(
                {
                    label: self.jsonData[0][i].name,
                    backgroundColor: areaColors[i],
                    borderColor: colors[i],
                    steppedLine: (chartType == 'stepped'?true:false),
                    data: [],
                    fill: (chartOption=='area'||chartOption=='areaWithDots'?true:false),
                    yAxisID: axesNames[i]
                }        
                )
            }
                        
            var firstDate = ''
            var lastDate = ''
            var dFirst,dLast
            if(self.multiLine){
                for (var j=0; j < self.jsonData[0].length && j<4; j++){
                    for (var i = 0; i < self.jsonData.length; i++){
                        chartData.datasets[j].data.push(self.jsonData[i][j]['value'])
                    }
                }
            }else{
                for (var i = 0; i < self.jsonData[0].length; i++){
                    chartData.datasets[0].data.push(self.jsonData[0][i]['value'])
                }  
            }
            dFirst=self.jsonData[0][0]['timestamp']
            dLast=self.jsonData[0][self.jsonData[0].length - 1]['timestamp']
            if (self.toLocaleTimeStringSupportsLocales()){    
                firstDate = new Date(dFirst).toLocaleString(app.language)
                lastDate = new Date(dLast).toLocaleString(app.language)    
            }else{
                firstDate = new Date(dFirst).toString()
                lastDate = new Date(dLast).toString()
            }

            var options = {
                responsive: true,
                plugins: {
                    title: {
                    display: false,
                    text: firstDate + ' - ' + lastDate
                    }
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var label = data.datasets[tooltipItem.datasetIndex].label || '';
                            if (label) {
                                label += ': ';
                            }
                            label += tooltipItem.yLabel;
                            return label;
                        },
                        title: function(tooltipItems, data){
                            return self.formatDate(new Date(tooltipItems[0].xLabel),true)
                        }
                    }
                },
                scales: {
                    x: {
                        ticks: {
                        callback: function(val, index) {
                        return ''+(index+1);
                        }
                        }
                    }
                },
                elements: {
                    point:{
                        radius: (chartOption=='plain'||chartOption=='area'?0:3)
                    }
                }
            }
            options.scales.yAxis1={
                        type: 'linear',
                        position: 'left',
                        display: true,
                        title: {
                            display: true,
                            text: self.jsonData[0][0]['name']
                        }
                        }
            options.scales.yAxis2={
                        type: 'linear',
                        position: 'right',
                        display: (self.multiLine && self.jsonData[0].length>1),
                        title: {
                            display: true,
                            text: (self.multiLine && self.jsonData[0].length>1)?self.jsonData[0][1]['name']:''
                        }
                        }
            options.scales.yAxis3={
                        type: 'linear',
                        position: 'right',
                        display: (self.multiLine && self.jsonData[0].length>2),
                        title: {
                            display: true,
                            text: (self.multiLine && self.jsonData[0].length>2)?self.jsonData[0][2]['name']:''
                        }
                        }
            options.scales.yAxis4={
                        type: 'linear',
                        position: 'right',
                        display: (self.multiLine && self.jsonData[0].length>3),
                        title: {
                            display: true,
                            text: (self.multiLine && self.jsonData[0].length>3)?self.jsonData[0][0]['name']:''
                        }
                        }
            if(numberOfLines==1){
                for (var i = 0; i < self.jsonData[0].length; i++){
                    if (self.toLocaleTimeStringSupportsLocales()){
                        chartData.labels.push(new Date(self.jsonData[0][i]['timestamp']).toLocaleString(app.language))
                    }else{
                        chartData.labels.push(new Date(self.jsonData[0][i]['timestamp']).toString())
                    }
                    //chartData.labels.push(new Date(self.jsonData[0][i]['timestamp']).toISOString())
                }
            }else{
                for (var i = 0; i < self.jsonData.length; i++){
                    if (self.toLocaleTimeStringSupportsLocales()){
                        chartData.labels.push(new Date(self.jsonData[i][0]['timestamp']).toLocaleString(app.language))
                    }else{
                        chartData.labels.push(new Date(self.jsonData[i][0]['timestamp']).toString())
                    }
                    //chartData.labels.push(new Date(self.jsonData[i][0]['timestamp']).toISOString())
                }
            }
            var chartConfig={
                    type: 'line',
                    data: chartData,
                    options: options
                }
            try{
                if(self.chart && !afterSwitch){
                    self.chart.data = chartData
                    self.chart.options = options
                    self.chart.update()
                }else{
                    self.chart = new Chart(self.ctxL, {
                        type: 'line',
                        data: chartData,
                        options: options
                    })
                }
            }catch(err){
                self.chart = new Chart(self.ctxL, chartConfig)
            }
    
        }

        switchCard(){
            return function(e){
                self.front = !self.front
                riot.update()
                self.showMultiLineGraph(self.type,true,self.chartOption)
            }
        }

        self.formatDate = function(myDate, full){
            if (full){
                return myDate.toLocaleString(getSelectedLocale())
            } else{
                return myDate.getHours() + ':' + myDate.getMinutes() + ':' + myDate.getSeconds()
            }
        }

        self.toLocaleTimeStringSupportsLocales = function() {
            try {
                new Date().toLocaleTimeString('i');
            } catch (e) {
                return e.name === 'RangeError';
            }
            return false;
        }

        $(window).on('resize', resize)

        function getWidth(){
            self.width = $('#' + opts.ref).width()
            self.heightStr = 'height:' + self.width + 'px;'
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
</widget_chart>