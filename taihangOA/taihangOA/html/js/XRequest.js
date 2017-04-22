define('XNet', ["jq"], function () {

    var $ = window.$;

    return {

        XGet: function (url, callBack) {
            console.log(url);

            $.support.cors = true;

            $.ajax
            ({

                type: "GET",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                url: url,  //这里是网址
                timeout: 15000, //超时时间
                success: function (data) {
                    console.log(data);
                    callBack(data);
                },
                error: function (err) {
                    console.log(err);
                    callBack({data:{code:1}});
                }
            });
        },


        XPost: function (url, data, callBack) {
            if(toast.isShow)
            {
                return;
            }

            console.log(url);

            toast.loading({
                title:null,
                duration:2000
            });

            $.support.cors = true;

            $.ajax
            ({
                type: "POST",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                data: data,
                url: url,  //这里是网址
                timeout: 15000, //超时时间
                success: function (data) {
                    toast.hide();
                    toast.remove();
                    console.log(data);
                    callBack(data);
                },
                error: function (err) {
                    toast.hide();
                    toast.remove();
                    console.log(err);
                    callBack({});
                }
            });
        },


        XDo: function (url, success,fail, callBack) {
            if(toast.isShow)
            {
                return;
            }

            console.log(url);

            toast.loading({
                title:null,
                duration:2000
            });

            $.support.cors = true;

            $.ajax
            ({
                type: "GET",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                url: url,  //这里是网址
                timeout: 15000, //超时时间
                success: function (data) {

                    console.log(data);

                    toast.hide();
                    toast.remove();

                    var code = data.data.code;
                    var msg = data.data.msg;
                    msg = msg == null || msg == undefined || msg == "" ? fail : msg;
                    if(code == 0)
                    {
                        if(success != null)
                        {
                            toast.success({
                                title:success,
                                duration:2000
                            });
                        }

                        callBack(true);

                        return;
                    }

                    toast.fail({
                        title:msg,
                        duration:2000
                    });
                    callBack(false);

                },
                error: function (err) {
                    toast.hide();
                    toast.remove();
                    toast.fail({
                        title:err,
                        duration:2000
                    });
                    callBack(false);
                }
            });
        },


        XDoPost: function (url, data,success,fail, callBack) {
            if(toast.isShow)
            {
                return;
            }

            console.log(url);

            toast.loading({
                title:null,
                duration:2000
            });

            $.each(data,function(key,value){

                console.log(key);
                console.log(value);

            });

            $.support.cors = true;

            $.ajax
            ({
                type: "POST",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                data: data,
                url: url,  //这里是网址
                timeout: 15000, //超时时间
                success: function (data) {

                    console.log(data);

                    toast.hide();
                    toast.remove();

                    var code = data.data.code;
                    var msg = data.data.msg;
                    msg = msg == null || msg == undefined || msg == "" ? fail : msg;
                    if(code == 0)
                    {
                        if(success != null)
                        {
                            toast.success({
                                title:success,
                                duration:2000
                            });
                        }

                        callBack(true);

                        return;
                    }

                    toast.fail({
                        title:msg,
                        duration:2000
                    });
                    callBack(false);

                },
                error: function (err) {

                    console.log(err.toString());

                    toast.hide();
                    toast.remove();
                    toast.fail({
                        title:err.toString(),
                        duration:2000
                    });
                    callBack(false);
                }
            });
        },


        XHttpUpload: function (url, data, callBack) {

            console.log(data);

            $.support.cors = true;

            $.ajax
            ({

                type: "POST",
                cache: false,
                dataType: "json",
                data: data,
                processData: false,
                contentType: false,
                url: url,  //这里是网址
                timeout: 15000, //超时时间
                success: function (data) {
                    console.log(data);
                    callBack(data);
                },
                error: function (err) {
                    console.log(err);
                    callBack(err);
                }
            });
        }

    }


});
