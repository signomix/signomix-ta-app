<widget_image>
    <div id={opts.ref} if={type == 'image'} class="container bg-white border border-light rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <img src={ imageUrl } class="img-fluid">
        </div> 
    </div>
    <script>
    var self = this
    // opts: poniższe przypisanie nie jest używane
    //       wywołujemy update() tego taga żeby zminieć parametry
    //self.type = opts.type
    // opts 
    self.color = 'bg-white'
    self.width=100
    self.heightStr='height:100px;'
    
    self.show2 = function(){
        app.log('SHOW2 '+self.type)
        getWidth()
    }
        
    $(window).on('resize', resize)
    
    function getWidth(){
        self.width=$('#'+opts.ref).width()
        self.heightStr='height:'+self.width+'px;'
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
</widget_image>