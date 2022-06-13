<app_footer>
    <footer class="footer container-fluid border-top text-signo text-right mt-4">
        <div class="row">
            <div class="col-md-10">
            <cs_article class="container" ref="homeart" path="/landingpage/app_footer.html" eventname="appMainArticleOK" erroreventname="appMainArticleErr" language={ app.language }></cs_article>
            </div>
            <div class="col-md-2 text-right">ver. {app.release}</div>
        </div>
    </footer>
    <script charset="UTF-8">
        var self = this;
        self.refs = []
        this.on('unmount', function () {
            Object.keys(self.refs).forEach(function (key) {
                self.refs[key].unmount()
            });
            self.refs = []
        })
        this.on('mount', function () {
            self.loadDocuments()
        })
        globalEvents.on('language', function () {
            self.loadDocuments()
        })
        self.loadDocuments = function () {
            self.messageVisible = true
            Object.keys(self.refs).forEach(function (key) {
                self.refs[key].updateContent()
            });
        }
    </script>
</app_footer>