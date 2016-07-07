/*
	Downloadify: Client Side File Creation
	JavaScript + Flash Library

	Version: 0.1

	Copyright (c) 2009 Douglas C. Neiner

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

(function(){Downloadify=window.Downloadify={queue:{},uid:(new Date).getTime(),getTextForSave:function(e){var t=Downloadify.queue[e];return t?t.getData():""},getFileNameForSave:function(e){var t=Downloadify.queue[e];return t?t.getFilename():""},saveComplete:function(e){var t=Downloadify.queue[e];return t&&t.complete(),!0},saveCancel:function(e){var t=Downloadify.queue[e];return t&&t.cancel(),!0},saveError:function(e){var t=Downloadify.queue[e];return t&&t.error(),!0},addToQueue:function(e){Downloadify.queue[e.queue_name]=e},getUID:function(e){return e.id==""&&(e.id="downloadify_"+Downloadify.uid++),e.id}},Downloadify.create=function(e,t){var n=typeof e=="string"?document.getElementById(e):e;return new Downloadify.Container(n,t)},Downloadify.Container=function(e,t){var n=this;n.el=e,n.enabled=!0,n.dataCallback=null,n.filenameCallback=null,n.data=null,n.filename=null;var r=function(){n.options=t,n.options.append||(n.el.innerHTML=""),n.flashContainer=document.createElement("span"),n.el.appendChild(n.flashContainer),n.queue_name=Downloadify.getUID(n.flashContainer),typeof n.options.filename=="function"?n.filenameCallback=n.options.filename:n.options.filename&&(n.filename=n.options.filename),typeof n.options.data=="function"?n.dataCallback=n.options.data:n.options.data&&(n.data=n.options.data);var e={queue_name:n.queue_name,width:n.options.width,height:n.options.height},r={allowScriptAccess:"always"},i={id:n.flashContainer.id,name:n.flashContainer.id};n.options.enabled===!1&&(n.enabled=!1),n.options.transparent===!0&&(r.wmode="transparent"),n.options.downloadImage&&(e.downloadImage=n.options.downloadImage),swfobject.embedSWF(n.options.swf,n.flashContainer.id,n.options.width,n.options.height,"10",null,e,r,i),Downloadify.addToQueue(n)};n.enable=function(){var e=document.getElementById(n.flashContainer.id);e.setEnabled(!0),n.enabled=!0},n.disable=function(){var e=document.getElementById(n.flashContainer.id);e.setEnabled(!1),n.enabled=!1},n.getData=function(){return n.enabled?n.dataCallback?n.dataCallback():n.data?n.data:"":""},n.getFilename=function(){return n.filenameCallback?n.filenameCallback():n.filename?n.filename:""},n.complete=function(){typeof n.options.onComplete=="function"&&n.options.onComplete()},n.cancel=function(){typeof n.options.onCancel=="function"&&n.options.onCancel()},n.error=function(){typeof n.options.onError=="function"&&n.options.onError()},r()},Downloadify.defaultOptions={swf:"media/downloadify.swf",downloadImage:"images/download.png",width:100,height:30,transparent:!0,append:!1}})(),typeof jQuery!="undefined"&&function(e){e.fn.downloadify=function(t){return this.each(function(){t=e.extend({},Downloadify.defaultOptions,t);var n=Downloadify.create(this,t);e(this).data("Downloadify",n)})}}(jQuery);