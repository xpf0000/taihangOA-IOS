/**
 * Created by Administrator on 2016/12/21 0021.
 */
//var BaseUrl = "http://182.92.70.85/hlppapi/Public/Found/?service=";
//https://api.ihlpp.com/Public/Found/?service=Common.getGuanggao&typeid=7

define('Service',["XNet",'store'], function(XNet,store) {
        return {

            BaseUrl : "http://apioa.sssvip.net/Public/taihangoa/?service=",
            Pagesize:10,

            //获取版本信息
            APPGetLastAPPVersion: function(callBack)
            {
                var url = this.BaseUrl+"APP.getLastAPPVersion";
                XNet.XGet(url, callBack);
            },

            //获取全部部门信息
            SystemGetDepartmentList: function(callBack)
            {
                var url = this.BaseUrl+"System.GetDepartmentList";
                XNet.XGet(url, callBack);
            },

            //获取全部车辆信息
            SystemGetCarList: function(callBack)
            {
                var url = this.BaseUrl+"System.getCarList";
                XNet.XGet(url, callBack);
            },

            //获取全部司机信息
            SystemGetDriverList: function(callBack)
            {
                var url = this.BaseUrl+"System.getDriverList";
                XNet.XGet(url, callBack);
            },

            //获取全部用途信息
            SystemGetPurposeList: function(callBack)
            {
                var url = this.BaseUrl+"System.getPurposeList";
                XNet.XGet(url, callBack);
            },


            //获取全部物品
            SystemGetResList: function(callBack)
            {
                var url = this.BaseUrl+"System.getResList";
                XNet.XGet(url, callBack);
            },

            //APP幻灯片
            SystemGetAPPSlide: function(callBack)
            {
                var url = this.BaseUrl+"System.getAPPSlide";
                XNet.XGet( url, callBack);
            },

            //获取通讯录
            UserGetAddressBook: function(uid,callBack)
            {
                if($.isFunction(uid))
                {
                    callBack = uid;
                    uid = 0;
                }
                var url = this.BaseUrl+"User.getAddressBook&uid="+uid;
                XNet.XGet(url, callBack);
            },

            //获取当前审批人
            TaskGetNowAuditor: function(uid,callBack)
            {
                var url = this.BaseUrl+"task.getNowAuditor";
                if(uid != null){url = url+"?uid="+uid}
                XNet.XGet(url, callBack);
            },


            //登陆
            Userlogin: function(mobile,password,callBack)
            {
                var url = this.BaseUrl+"User.login";

                XNet.XPost( url,{mobile:mobile,password:password}, callBack);
            },

            //获取个人信息
            UsergetUserInfo: function(id,account,callBack)
            {
                var url = this.BaseUrl+"User.getUserInfo&id="+id+"&account="+account;
                XNet.XGet( url, callBack);
            },

            //通知公告列表
            NoticeGetNoticeList: function(page,callBack)
            {
                var url = this.BaseUrl+"notice.getNoticeList&page="+page+"&pagesize="+this.Pagesize;
                XNet.XGet( url, callBack);
            },

            //通知公告详情
            NoticeGetNoticeArticle: function(id,callBack)
            {
                var url = this.BaseUrl+"notice.getNoticeArticle&id="+id;
                XNet.XGet( url, callBack);
            },

            //短信验证码发送 类型；1，注册验证2，变更验证
            SmsSmsSend: function(mobile,type,callBack)
            {
                var url = this.BaseUrl+"Sms.smsSend&mobile="+mobile+"&type="+type;
                XNet.XDo(url,"短信发送成功","短信发送失败",callBack);

            },

            //短信验证
            SmsSmsVerify: function(mobile,code,callBack)
            {
                var url = this.BaseUrl+"sms.smsVerify&mobile="+mobile+"&code="+code;
                XNet.XDo(url,null,"验证码验证失败",callBack);

            },

            //注册
            UserRegister: function(data,callBack)
            {
                var url = this.BaseUrl+"User.Register&mobile="+data.mobile+"&password="+
                    data.password+"&name="+data.name+"&did="+data.did+"&sex="+data.sex;
                XNet.XDo(url,null,"注册失败",callBack);
            },

            //添加车辆申请
            TaskAddTaskCar: function(data,callBack)
            {
                var user = store.get("User");
                data.uid = user.id;
                data.mobile = user.account;

                var url = this.BaseUrl+"task.addTaskCar";
                XNet.XDoPost(url,data,null,"添加车辆申请失败",callBack);
            },

            //车辆申请列表
            TaskGetTaskCarList: function(page,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskCarList&page="+page+"&pagesize="+this.Pagesize+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //车辆申请详情
            TaskGetTaskCarInfo: function(id,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskCarInfo&id="+id+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },


            //物品申请列表
            TaskGetTaskResList: function(page,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskResList&page="+page+"&pagesize="+this.Pagesize+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //物品申请详情
            TaskGetTaskResInfo: function(id,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskResInfo&id="+id+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },


            //添加物品申请
            TaskAddTaskRes: function(data,callBack)
            {
                var user = store.get("User");
                data.uid = user.id;
                data.mobile = user.account;

                var url = this.BaseUrl+"task.addTaskRes";
                XNet.XDoPost(url,data,null,"添加物品申请失败",callBack);
            },


            //督查督办申请列表
            TaskGetTaskOverseerList: function(page,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskOverseerList&page="+page+"&pagesize="+this.Pagesize+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //添加督查督办申请
            TaskAddTaskOverseer: function(data,callBack)
            {
                var user = store.get("User");
                data.uid = user.id;
                data.mobile = user.account;

                var url = this.BaseUrl+"Task.AddTaskOverseer";
                XNet.XDoPost(url,data,null,"添加督查督办事项失败",callBack);
            },

            //督察督办申请详情
            TaskGetTaskOverseerInfo: function(id,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.getTaskOverseerInfo&id="+id+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //任务操作
            TaskDoAction: function(taskid,action,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.doAction&taskid="+taskid+"&action="+action+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XDo(url,"操作成功！","操作失败",callBack);
            },

            //待办列表
            TaskGetTaskDaibanList: function(page,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.GetTaskDaibanList&page="+page+"&pagesize="+this.Pagesize+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //已完成任务列表
            TaskGetTaskHistoryList: function(page,callBack)
            {
                var user = store.get("User");
                var url = this.BaseUrl+"task.GetTaskHistoryList&page="+page+"&pagesize="+this.Pagesize+
                    "&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },

            //代办列表总数
            TaskGetTaskDaibanCount: function(callBack)
            {
                var user = store.get("User");

                if(!user)
                {
                    return;
                }

                var url = this.BaseUrl+"task.GetTaskDaibanCount&uid="+user.id+"&mobile="+user.account;
                XNet.XGet( url, callBack);
            },


            //添加反馈意见
            SystemAddFeedback: function(content,callBack)
            {
                var url = this.BaseUrl+"system.addFeedback&title=反馈意见&content="+content;
                XNet.XDo( url,null,"新增反馈意见失败",callBack);
            },


            //更新用户信息
            UserUpdateEmployee: function(data,callBack)
            {
                var url = this.BaseUrl+"User.UpdateEmployee";
                XNet.XDoPost( url,data,null,"用户手机号码修改失败",callBack);
            },

            //更新用户手机号
            UserupdateMobile: function(data,callBack)
            {
                var url = this.BaseUrl+"User.UpdateMobile";
                XNet.XDoPost( url,data,null,"用户手机号码修改失败",callBack);
            },


            //重设密码
            UserResetPass: function(mobile,code,password,callBack)
            {
                var url = this.BaseUrl+"User.ResetPass&mobile="+mobile+"&code="+code+"&password="+password;
                XNet.XDo(url,null,"密码重置失败",callBack);

            },

            //增加活动收藏信息
            articleAddCollect: function(id,user,callBack)
            {
                var url = this.BaseUrl+"Article.addCollect&id="+id+"&uid="+user.id+"&username="+user.username;

                XHttpDo( url,"收藏成功","收藏失败",callBack);

            },


        }

    }
);





