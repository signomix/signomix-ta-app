<raw>
    this.root.innerHTML=opts.content
    this.on('mount',function(){
        app.log('MOUNT RAW')
        app.log('HTML='+opts.content)
    })
    this.on('update',function(){
        this.root.innerHTML=opts.content
    })
</raw>
