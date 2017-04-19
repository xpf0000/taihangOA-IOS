function handleClicks(e) {
    var clicked = $(this);
    if(clicked.hasClass('back'))
    {
        if(clicked.data("back"))
        {
            sendMsgToAPP({'type':1,msg:'页面返回',back:'root'});
        }
        else
        {
            sendMsgToAPP({'type':1,msg:'页面返回'});
        }

        return false;
    }

    var url = clicked.attr('href');

    if(!url || url.indexOf('#') == 0 || url.indexOf('tel:') == 0)
    {
        return true;
    }

    if(url != undefined && url != null && url.indexOf('#') != 0 && url.indexOf('javascript:')<0)
    {
        sendMsgToAPP({'type':0,msg:'url跳转',url:url});
    }

    return false;

}

$(document).on('click', 'a', handleClicks);

var ImagePrefix = 'http://adminoa.sssvip.net/data/upload/';

var APPSex = {1:'男',2:'女'};
var TaskState = {0:'等待审核',1:'等待修改',2:'审核未通过',3:'审核通过',4:'等待接受',5:'拒绝接受',6:'等待完成',7:'已完成',8:'已取消'};
var TaskAction = {0:'创建',1:'同意',2:'拒绝',3:'退回',4:'修改',5:'撤回',6:'删除',7:'完成'};
var TaskOverseerAction = {0:'创建',1:'接受',2:'拒绝',3:'退回',4:'修改',5:'撤回',6:'删除',7:'完成'};