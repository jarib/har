require.def("tabs/homeTab",["domplate/domplate","domplate/tabView","core/lib","core/cookies","core/trace","i18n!nls/homeTab",'text!tabs/homeTab.html!<div>\r\n<ul style="padding-left: 20px; line-height: 20px; margin-top: 0px">\r\n<li>Paste <a href="@HAR_SPEC_URL@">HAR</a>\r\nlog into the text box below and\r\npress the <b>Preview</b> button.</li>\r\n<li>Or drop <span class="red">*.har</span> file(s) anywhere on the page (if your browser supports that).</li>\r\n</ul>\r\n<table cellpadding="0" cellspacing="4">\r\n    <tr>\r\n        <td><input type="checkbox" id="validate" checked="true"></input></td>\r\n        <td style="vertical-align:middle;padding-bottom: 1px;">Validate data before processing?</td>\r\n    </tr>\r\n</table>\r\n<textarea id="sourceEditor" class="sourceEditor" cols="80" rows="5"></textarea>\r\n<p><table cellpadding="0" cellspacing="0">\r\n    <tr>\r\n        <td><button id="appendPreview">Preview</button></td>\r\n    </tr>\r\n</table></p>\r\n<br/>\r\n<h3>HAR Log Examples</h3>\r\n<ul style="line-height:20px;">\r\n<li><span id="example1" class="link example" path="examples/inline-scripts-block.har">\r\nInline scripts block</span> - Inline scripts block the page load.</li>\r\n<li><span id="example2" class="link example" path="examples/browser-blocking-time.har">\r\nBlocking time</span> - Impact of a limit of max number of parallel connections.</li>\r\n<li><span id="example3" class="link example" path="examples/softwareishard.com.har">\r\nBrowser cache</span> - Impact of the browser cache on page load (the same page loaded three times).</li>\r\n<li><span id="example4" class="link example" path="examples/google.com.har">\r\nSingle page</span> - Single page load (empty cache).</li>\r\n</ul>\r\n<br/>\r\n<p><i>This viewer supports HAR 1.2 (see the <span class="linkAbout link">About</span> tab).<br/></i></p>\r\n</div>\r\n',
"preview/harModel"],function(d,h,c,e,i,g,j){with(d){d=function(){};d.prototype=c.extend(h.Tab.prototype,{id:"Home",label:g.homeTabLabel,bodyTag:DIV({"class":"homeBody"}),onUpdateBody:function(a,b){b=this.bodyTag.replace({},b);b.innerHTML=j.replace("@HAR_SPEC_URL@",a.harSpecURL,"g");$("#appendPreview").click(c.bindFixed(this.onAppendPreview,this));$(".linkAbout").click(c.bind(this.onAbout,this));a=$("#content");a.bind("dragenter",c.bind(c.cancelEvent,c));a.bind("dragover",c.bind(c.cancelEvent,c));
a.bind("drop",c.bind(this.onDrop,this));this.validateNode=$("#validate");if(a=e.getCookie("validate"))this.validateNode.attr("checked",a=="false"?false:true);this.validateNode.change(c.bind(this.onValidationChange,this));$(".example").click(c.bind(this.onLoadExample,this))},onAppendPreview:function(a){a||(a=$("#sourceEditor").val());a&&this.tabView.appendPreview(a)},onAbout:function(){this.tabView.selectTabByName("About")},onValidationChange:function(){var a=this.validateNode.attr("checked");e.setCookie("validate",
a)},onLoadExample:function(a){a=$.event.fix(a||window.event).target.getAttribute("path");var b=document.location.href,f=b.indexOf("?");document.location=b.substr(0,f)+"?path="+a;e.setCookie("timeline",true);e.setCookie("stats",true)},onDrop:function(a){var b=$.event.fix(a||window.event);c.cancelEvent(b);try{this.handleDrop(a.originalEvent.dataTransfer)}catch(f){i.exception("HomeTab.onDrop EXCEPTION",f)}},handleDrop:function(a){if(!a)return false;if(a=a.files)for(var b=0;b<a.length;b++)this.onAppendPreview(a[b].getAsText(""))},
loadInProgress:function(a,b){$("#sourceEditor").val(a?b?b:g.loadingHar:"")}});return d}});