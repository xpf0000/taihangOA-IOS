require.config({
    baseUrl: '../js',  //相对于index.html页面文件的地址
    paths:{   //这里配置的地址，都是相对于上方的baseUrl的
        vue: 'vue',
        domReady:'domReady',
        jq:'jquery-1.9.1.min',
        app:'app',
        auislide:'aui-slide',
        toast:'aui-toast',
        actionsheet:'aui-actionsheet',
        auirefresh:'aui-pull-refresh',
        auidialog:'aui-dialog',
        auicollapse:'aui-collapse',
        dropload:'dropload',
        api:'api',
        XNet:'XRequest',
        Service:'serviceApi',
        store:'store',
        json2:'json2',
        swiper:'swiper-3.4.2.jquery.min',
    },
    shim:{
        vue: { deps: ['domReady'],exports: "vue" },
        app:{deps:['jq'],exports: "app"},
        dropload:{deps:['jq'],exports: "dropload"},
        store:{ deps: ['json2']},
        swiper:{deps:['jq'],exports: "swiper"},
    }
});


require(['toast','Service'], function(toast,Service) {

    window.toast = new auiToast({});
    window.Service = Service;

});

var Base64 = {
    _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
    encode: function(a) {
        var b,
            c,
            d,
            e,
            f,
            g,
            h,
            i = "",
            j = 0;
        for (a = Base64._utf8_encode(a); j < a.length;)
            b = a.charCodeAt(j++), c = a.charCodeAt(j++), d = a.charCodeAt(j++), e = b >> 2, f = (3 & b) << 4 | c >> 4, g = (15 & c) << 2 | d >> 6, h = 63 & d, isNaN(c) ? g = h = 64 : isNaN(d) && (h = 64), i = i + this._keyStr.charAt(e) + this._keyStr.charAt(f) + this._keyStr.charAt(g) + this._keyStr.charAt(h);
        return i
    },
    decode: function(a) {
        var b,
            c,
            d,
            e,
            f,
            g,
            h,
            i = "",
            j = 0;
        for (a = a.replace(/[^A-Za-z0-9\+\/\=]/g, ""); j < a.length;)
            e = this._keyStr.indexOf(a.charAt(j++)), f = this._keyStr.indexOf(a.charAt(j++)), g = this._keyStr.indexOf(a.charAt(j++)), h = this._keyStr.indexOf(a.charAt(j++)), b = e << 2 | f >> 4, c = (15 & f) << 4 | g >> 2, d = (3 & g) << 6 | h, i += String.fromCharCode(b), 64 != g && (i += String.fromCharCode(c)), 64 != h && (i += String.fromCharCode(d));
        return i = Base64._utf8_decode(i)
    },
    _utf8_encode: function(a) {
        a = a.replace(/\r\n/g, "\n");
        for (var b = "", c = 0; c < a.length; c++) {
            var d = a.charCodeAt(c);
            d < 128 ? b += String.fromCharCode(d) : d > 127 && d < 2048 ? (b += String.fromCharCode(d >> 6 | 192), b += String.fromCharCode(63 & d | 128)) : (b += String.fromCharCode(d >> 12 | 224), b += String.fromCharCode(d >> 6 & 63 | 128), b += String.fromCharCode(63 & d | 128))
        }
        return b
    },
    _utf8_decode: function(a) {
        for (var b = "", c = 0, d = c1 = c2 = 0; c < a.length;)
            d = a.charCodeAt(c), d < 128 ? (b += String.fromCharCode(d), c++) : d > 191 && d < 224 ? (c2 = a.charCodeAt(c + 1), b += String.fromCharCode((31 & d) << 6 | 63 & c2), c += 2) : (c2 = a.charCodeAt(c + 1), c3 = a.charCodeAt(c + 2), b += String.fromCharCode((15 & d) << 12 | (63 & c2) << 6 | 63 & c3), c += 3);
        return b
    }
};

var observers = [];

function OnNotice(key,callback)
{
    var k = -1;
    for(var i in observers)
    {
        var item = observers[i];

        if(item.key == key)
        {
            k = i;
            break;
        }
    }

    if(k >= 0)
    {
        var item = observers[k];
        item.key = null;
        item.callback = null;
        item = null;

        observers.splice(k,1);
    }

	var obj = {
		"key" : key,
		"callback":callback
		};
	observers.push(obj);
}

function postNotice(key,obj)
{
	for(var i in observers)
	{
		var item = observers[i];
		
		if(item.key == key)
		{
			item.callback(obj);
			break;
		}
	}
}

Array.prototype.del=function(n) {　//n表示第几项，从0开始算起。
//prototype为对象原型，注意这里为对象增加自定义方法的方法。
    if(n<0)　//如果n<0，则不进行任何操作。
        return this;
    else
        return this.slice(0,n).concat(this.slice(n+1,this.length));
    /*
     　concat方法：返回一个新数组，这个新数组是由两个或更多数组组合而成的。
     　这里就是返回this.slice(0,n)/this.slice(n+1,this.length)
     组成的新数组，这中间，刚好少了第n项。
     　slice方法： 返回一个数组的一段，两个参数，分别指定开始和结束的位置。
     */
}

Array.prototype.insert = function (index, item) {
    this.splice(index, 0, item);
};

String.prototype.replaceAll = function(s1,s2){
    return this.replace(new RegExp(s1,"gm"),s2);
}

function getUrlParam(name)
{
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        return decodeURIComponent(r[2]);
    return null;
}

//只能输入数字
function onlyNumber(event){
	

   var keyCode = event.keyCode;   
  
     if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105) || keyCode == 8)    
    {   
	    
	    
         event.returnValue = true;    
     } else {    
	     
	      event.preventDefault();  
          event.returnValue = false;    
    }       
    
    
}

//发送验证码时添加cookie
function addCookie(name,value,expiresHours){ 
  var cookieString=name+"="+escape(value); 
  
  console.log(cookieString);
  
  //判断是否设置过期时间,0代表关闭浏览器时失效
  if(expiresHours>0){ 
    var date=new Date(); 
    date.setTime(date.getTime()+expiresHours*1000); 
    cookieString=cookieString+";expires=" + date.toUTCString(); 
  } 
  
   console.log(cookieString);
  
    document.cookie=cookieString; 
} 

//修改cookie的值
function editCookie(name,value,expiresHours){ 
  var cookieString=name+"="+escape(value); 
  if(expiresHours>0){ 
   var date=new Date(); 
   date.setTime(date.getTime()+expiresHours*1000); //单位是毫秒
   cookieString=cookieString+";expires=" + date.toGMTString(); 
  } 
   document.cookie=cookieString; 
} 

//根据名字获取cookie的值
function getCookieValue(name)
{ 
   var strCookie=document.cookie; 
   
   var arrCookie=strCookie.split("; "); 
   
   for(var i=0;i<arrCookie.length;i++){ 
	   
    var arr=arrCookie[i].split("="); 
    
    if(arr[0]==name)
    {
     return unescape(arr[1]);
    }
         
   } 
   
   return "";
     
}

function sendMsgToAPP(json)
    {
	    console.log(json);
	    
        try    {
            window.webkit.messageHandlers.JSHandle.postMessage(JSON.stringify(json));
        }
        catch  (e)
        {
            try
                {
                    APP.jsMessage(JSON.stringify(json));
            }
            catch(e)
            {
	            try
	            {
		            window.android.runAndroidMethod(JSON.stringify(json));
	            }
	            catch(e)
	            {
		            
	            }
                
            }
            
        }
        
}

function validatemobile(mobile) 
   {
       var str = "";
       if(mobile.length==0 && str == "")
       {
           str = '请输入手机号码！';
       }

       if(mobile.length!=11 && str == "")
       {
           str = '请输入有效的手机号码！';
       } 
        
       var myreg = /0?(13|15|18|17)[0-9]{9}/; 
       if(!myreg.test(mobile) && str == "")
       {
           str = '请输入有效的手机号码！';
       }

       if(str != "")
       {
           toast.fail({
               title:str,
               duration:2000
           });
       }
       
       return str == "";
   } 


var DateTimeUtil =  {
	
	
			TimeZone : 8,	
            /**
             * 当前时间戳
             * @return <int>        unix时间戳(秒)
             */
            CurTime: function() {
                return Date.parse(new Date()) / 1000;
            },
            /**
             * 日期 转换为 Unix时间戳
             * @param <string> 2014-01-01 20:20:20  日期格式
             * @return <int>        unix时间戳(秒)
             */
            DateToUnix: function(string) {
                var f = string.split(' ', 2);
                var d = (f[0] ? f[0] : '').split('-', 3);
                var t = (f[1] ? f[1] : '').split(':', 3);
                return (new Date(
                        parseInt(d[0], 10) || null,
                        (parseInt(d[1], 10) || 1) - 1,
                        parseInt(d[2], 10) || null,
                        parseInt(t[0], 10) || null,
                        parseInt(t[1], 10) || null,
                        parseInt(t[2], 10) || null
                    )).getTime() / 1000;
            },
            /**
             * 时间戳转换日期
             * @param <int> unixTime    待时间戳(秒)
             * @param <bool> isFull    返回完整时间(Y-m-d 或者 Y-m-d H:i:s)
             * @param <int>  timeZone   时区
             */
            UnixToDate: function(unixTime, isFull, timeZone) {
                if (typeof (timeZone) != 'number')
                {
                    timeZone = this.TimeZone;
                }
                unixTime = parseInt(unixTime) + parseInt(timeZone) * 60 * 60;
                var time = new Date(unixTime * 1000);
                
                var ymdhis = "";
                ymdhis += time.getUTCFullYear() + "-";
                ymdhis += (time.getUTCMonth() + 1) + "-";
                ymdhis += time.getUTCDate();
                if (isFull === true)
                {
                    ymdhis += " " + time.getUTCHours() + ":";
                    ymdhis += time.getUTCMinutes() + ":";
                    ymdhis += time.getUTCSeconds();
                }
                return ymdhis;
            },

            UnixToDateFormat: function(unixTime, format ,timeZone) {
                if (typeof (timeZone) != 'number')
                {
                    timeZone = this.TimeZone;
                }
                unixTime = parseInt(unixTime) + parseInt(timeZone) * 60 * 60;
                var time = new Date(unixTime * 1000);

                var ymdhis = "";

                if(format)
                {
                    ymdhis = format;
                    ymdhis = ymdhis.replace("yyyy", time.getUTCFullYear()+"");

                    var month = (time.getUTCMonth() + 1)+"";
                    if(month.length < 2)
                    {
                        ymdhis = ymdhis.replace("MM", "0"+month);
                    }
                    ymdhis = ymdhis.replace("MM", month);
                    ymdhis = ymdhis.replace("M", month);


                    var day = time.getUTCDate()+"";
                    if(day.length < 2)
                    {
                        ymdhis = ymdhis.replace("dd", "0"+day);
                    }
                    ymdhis = ymdhis.replace("dd", day);
                    ymdhis = ymdhis.replace("d", day);


                    var hours = time.getUTCHours()+"";
                    if(hours.length < 2)
                    {
                        ymdhis = ymdhis.replace("HH", "0"+hours);
                    }
                    ymdhis = ymdhis.replace("HH", hours);
                    ymdhis = ymdhis.replace("H", hours);


                    var minutes = time.getUTCMinutes()+"";
                    if(minutes.length < 2)
                    {
                        ymdhis = ymdhis.replace("mm", "0"+minutes);
                    }
                    ymdhis = ymdhis.replace("mm", minutes);
                    ymdhis = ymdhis.replace("m", minutes);


                    var seconds = time.getUTCSeconds()+"";
                    if(seconds.length < 2)
                    {
                        ymdhis = ymdhis.replace("ss", "0"+seconds);
                    }
                    ymdhis = ymdhis.replace("ss", seconds);
                    ymdhis = ymdhis.replace("s", seconds);

                }
                else
                {
                    ymdhis += time.getUTCFullYear() + "-";
                    ymdhis += (time.getUTCMonth() + 1) + "-";
                    ymdhis += time.getUTCDate();
                    ymdhis += " " + time.getUTCHours() + ":";
                    ymdhis += time.getUTCMinutes() + ":";
                    ymdhis += time.getUTCSeconds();

                }

                return ymdhis;
            },



            /**
             * [dateDiff 算时间差]
             * @param  {[type=Number]} hisTime [历史时间戳，必传]
             * @param  {[type=Number]} nowTime [当前时间戳，不传将获取当前时间戳]
             * @return {[string]}         [string]
             */
            DateDiff : function(hisTime,nowTime)
            {
                if(!arguments.length) return '';
                var arg = arguments,
                    now =arg[1]?arg[1]:new Date().getTime()/1000,
                    diffValue = now - arg[0],
                    result='',

                    minute = 60,
                    hour = minute * 60,
                    day = hour * 24,
                    halfamonth = day * 15,
                    month = day * 30,
                    year = month * 12,

                    _year = diffValue/year,
                    _month =diffValue/month,
                    _week =diffValue/(7*day),
                    _day =diffValue/day,
                    _hour =diffValue/hour,
                    _min =diffValue/minute;

                if(_year>=1) result=parseInt(_year) + "年前";
                else if(_month>=1) result=parseInt(_month) + "个月前";
                else if(_week>=1) result=parseInt(_week) + "周前";
                else if(_day>=1) result=parseInt(_day) +"天前";
                else if(_hour>=1) result=parseInt(_hour) +"个小时前";
                else if(_min>=1) result=parseInt(_min) +"分钟前";
                else result="刚刚";
                return result;
            }


        };




