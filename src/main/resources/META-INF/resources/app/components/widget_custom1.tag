<widget_custom1>
    <div id="{ref}" ref="{ref}" if="{type == 'custom1'}" class="container-fluid bg-white border border-info rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <div class="col-12 text-center {app.wt_color||'text-white'} sgx-wt" onclick={ switchCard()}><span class="text-body">{title.length>0?('&nbsp;'+title+'&nbsp;'):''}</span></div>
        </div> 
        <div class="row px-3 py-1" if={ front }>
                <div class="col-12" ref={ref+'_col'} id={ref+'_col'}>
                    <canvas ref={ref+'_canvas'} id={ref+'_canvas'} width={canvasWidth} height={canvasHeight}></canvas>
                </div>
        </div>
        <div class="row px-3 py-1" if={ !front }>
            <div if={ ! dataAvailable} class="col-12">
                <p>{ app.texts.widget.nodata[app.language] }</p>
            </div>
            <div if={dataAvailable} class="col-12 p-1">
            <pre>{ JSON.stringify(jsonData,null,2) }</pre>
            </div>
        </div>
    </div>
    <script>
        var self = this

        self.front = true
        self.rawdata = "[]"
        self.jsonData = []
        app.log('self.ref: '+self.ref)
        app.log(this.refs)
        self.canvasElement = this.refs[(self.ref)+'_canvas']
        self.canvasWidth = 100
        self.canvasHeight = 100
        self.dataAvailable=false;

        this.on('mount',function(){
            getWidth()
        })

        self.show2 = function(){
            self.jsonData = JSON.parse(this.rawdata)
            app.log(self.jsonData)
            if (self.jsonData.length == 0 || self.jsonData[0].length == 0){
                self.dataAvailable=false;
                return;
            }
            self.dataAvailable=true;
            getWidth()
            self.drawContent()
        }

        self.drawContent = function(){
            if(!self.front) return;
            self.canvasElement = this.refs[(self.ref)+'_canvas']
            if(!drawDedicated(self.canvasElement, self.jsonData, self.unitName, self.rounding)) {
                drawDefault(self.canvasElement)
            }
            riot.update()
        }

        function drawDedicated(canvas,list,unitName, rounding){
            //put your code here and return true
            app.log('drawCustom() is not used')
            return false;
        }

        function drawDefault(canvas){
            app.log('drawDefault')
            var ctx=canvas.getContext('2d')
            ctx.clearRect(0,0,canvas.width,canvas.height)
            ctx.fillStyle = 'rgb(255, 255, 255)';
            ctx.fillRect(0,0,canvas.width,canvas.height)

            ctx.strokeStyle = 'rgb(0, 0, 0)';
            ctx.beginPath()
            //diagonal 1
            ctx.moveTo(0,0)
            ctx.lineTo(canvas.width,canvas.height)
            //diagonal2
            ctx.moveTo(0,canvas.height)
            ctx.lineTo(canvas.width,0)
            //arrow 1
            ctx.moveTo(0,0)
            ctx.lineTo(0,20)
            ctx.moveTo(0,0)
            ctx.lineTo(20,0)
            //arrow 2
            ctx.moveTo(canvas.width,canvas.height)
            ctx.lineTo(canvas.width,canvas.width-20)
            ctx.moveTo(canvas.width,canvas.height)
            ctx.lineTo(canvas.width-20,canvas.width)
            //arrow 3
            ctx.moveTo(0,canvas.height)
            ctx.lineTo(0,canvas.height-20)
            ctx.moveTo(0,canvas.height)
            ctx.lineTo(20,canvas.height)
            //arrow 4
            ctx.moveTo(canvas.width,0)
            ctx.lineTo(canvas.width,20)
            ctx.moveTo(canvas.width,0)
            ctx.lineTo(canvas.width-20,0)

            ctx.stroke()
        }

        switchCard(){
            return function(e){
                self.front = !self.front
                riot.update()
                if(self.front){
                    self.drawContent()
                }
            }
        }

    function getWidth(){
        self.canvasWidth=$('#'+self.ref+'_col').width()
        self.canvasHeight=self.canvasWidth
        riot.update()
    }
    
    function resizeWidget(){
        getWidth()
        self.drawContent()
    }

    window.onresize = resizeWidget

    </script>
    <style>
        .topspacing{
            margin-top: 10px;
        }
    </style>
</widget_custom1>