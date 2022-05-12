<widget_bar>
    <div id="{ref}" ref={ref} if="{type == 'bar'}" class="container-fluid bg-white border border-info rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <div class="col-12 text-center {app.wt_color||'text-white'} sgx-wt" onclick={ switchCard()}><span class="text-body">{title.length>0?('&nbsp;'+title+'&nbsp;'):''}</span></div>
        </div> 
        <div class="row px-3 py-1" if={ front }>
                <div class="col-12">
                    <canvas ref={ref+'_canvas'} id={ref+'_canvas'}></canvas>
                </div>
        </div>
        <div class="row px-3 py-1" if={ !front }>
            <div if={ ! dataAvailable} class="col-12">
                <p>{ app.texts.widget.nodata[app.language] }</p>
            </div>
            <div if={dataAvailable} class="col-12 table-responsive">
            <table id="devices" class="table table-condensed">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">{ app.texts.widget.timestamp[app.language] }</th>
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
        self.canvasElement = this.refs[(self.ref)+'_canvas']
        self.ctxL = {}
        self.chart = {}
        self.width = 100
        self.heightStr = 'height:100px;'
        self.multiLine = false
        self.dataAvailable=false;

        self.show2 = function(){
            self.jsonData = JSON.parse(this.rawdata)
            app.log(self.jsonData)
            if (self.jsonData.length == 0 || self.jsonData[0].length == 0){
                self.dataAvailable=false;
                return;
            }
            self.dataAvailable=true;
            getWidth()
            //self.multiLine = self.jsonData[0].length > 1 && self.jsonData[0][1]['name'] != self.jsonData[0][0]['name']
            self.multiLine=false
            self.showBarGraph(self.type,false)
        }
        
        self.showBarGraph = function(chartType,afterSwitch){
            if (!self.front || self.jsonData[0].length == 0 ){ 
                app.log('return because '+self.front+' '+self.jsonData[0].length)
                return 
            }
            self.canvasElement = this.refs[(self.ref)+'_canvas']
            self.ctxL = self.canvasElement.getContext('2d')
            var minWidth = 400
            var largeSize = self.width > minWidth
            
            var chartData = {
                labels: [],
                datasets: []
            }
                        
            var firstDate = ''
            var lastDate = ''
            var dFirst,dLast;
            var measures = []
            var borders =[]
            var colors =[] 
            
            for (var i = 0; i < self.jsonData[0].length; i++){
                    chartData.labels.push(
                        self.formatDate(new Date(self.jsonData[0][i]['timestamp']),true)
                    )
                    measures.push(self.jsonData[0][i]['value'])
                    colors.push('rgba(54, 162, 235, 0.2)')
                    borders.push('rgb(54, 162, 235)')
            }

            chartData.datasets.push(
                        {
                            label:self.jsonData[0].length>0?self.jsonData[0][0]['name']:'',
                            borderWidth:1,
                            data: measures,
                            backgroundColor: colors,
                            borderColor: borders
                        }
                    )
            dFirst=self.jsonData[0][0]['timestamp']
            dLast=self.jsonData[0][self.jsonData[0].length - 1]['timestamp']
            
            if (self.toLocaleTimeStringSupportsLocales()){
                firstDate = new Date(dFirst).toLocaleDateString(app.language)
                lastDate = new Date(dLast).toLocaleDateString(app.language)    
            }else{
                firstDate = new Date(dFirst).toISOString().substring(0, 10)
                lastDate = new Date(dLast).toISOString().substring(0, 10)
            }
            
            var barChartOptions = {
                scales:{
                    y:{
                        //beginAtZero: true,
                        suggestedMin: 0
                    },
                    x:{
                        ticks: {
                            callback: function(value, index, ticks) {
                                return '' + (index+1);
                            }
                          }
                    }
                }
            }
            var barCharConfig={
                        type: 'bar',
                        data: chartData,
                        options: barChartOptions
                    }
            
            try{
                if(self.chart && !afterSwitch){
                    self.chart.data = chartData
                    self.chart.options = barChartOptions
                    self.chart.update()
                }else{
                    if(self.chart instanceof Chart)
                    {
                        self.chart.destroy();
                    }
                    self.chart = new Chart(self.ctxL, barCharConfig)
                    
                }
            }catch(err){
                if(self.chart instanceof Chart)
                {
                    self.chart.destroy();
                }
                self.chart = new Chart(self.ctxL, barCharConfig)
            }
            
        }

        switchCard(){
            return function(e){
                self.front = !self.front
                riot.update()
                self.showBarGraph(self.type,true)
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
</widget_bar>