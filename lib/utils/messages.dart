import 'package:get/get.dart';

/// 语言资源
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'toast.connection_error': '警告：网络不可用！',
          'client.version': '版本 ',
          'login.name': '锐安会议',
          'login.email': '邮箱',
          'login.email.hint': '请输入邮箱',
          'login.pwd.hint': '请输入密码',
          'login.pwd': '密码',
          'login.btn': '登录',
          'login.welcome': '欢迎登录',
          'login.back_to_login': '返回登陆',
          'check.enter.valid.email': '请输入有效邮箱',
          'check.enter.pwd.required': '请输入密码',
          'login.fail': '登录失败，请重试',
          'login.success': '登录成功，跳转中...',
          'nav.meeting': '会议',
          'nav.profile': '我的',
          'title.meeting': '会议',
          'btn.confirm': '确定',
          'btn.cancel': '取消',
          'btn.new_meeting': '新会议',
          'btn.join_meeting': '加入',
          'btn.join_meeting_without_login': '免登陆加会',
          'btn.schedule_meeting': '安排会议',
          'btn.del_meeting': '删除',
          'btn.exit_app': '退出登录',
          'text.meeting_numb': '会议号: ',
          'title.start_meeting': '开始会议',
          'title.schedule_meeting.submit': '预约会议',
          'title.edit_meeting.submit': '编辑会议',
          'confirm.schedule_meeting.submit': '您确定提交吗?',
          'switch.enable_video': '开启视频',
          'switch.use_pmi': '使用个人会议号',
          'btn.start_meeting': '开始会议',
          'btn.edit_meeting': '编辑会议',
          'list.no_schedule_meeting': '没有即将召开的会议',
          'toast.init_app_failed': '初始化应用失败!',
          'toast.init_app_success': '初始化应用成功!',
          'toast.auto_login_success': '自动登录成功',
          'toast.auto_login_failed': '用户自动登录失败',
          'toast.schedule_meeting.submit.fail': '预约会议失败',
          'toast.edit_meeting.submit.fail': '编辑会议失败',
          'toast.schedule_meeting.submit.success': '会议预约成功!',
          'toast.edit_meeting.submit.success': '编辑会议成功',
          'toast.delete_meeting.failed': '删除会议失败',
          'toast.get_meeting.failed': '获取会议失败',
          'toast.login_must_agree_disclaimer': '请先同意服务协议和隐私政策',
          'meeting.detail': '会议详情',
          'text.meeting_topic': '主题',
          'meeting.start_time': '时间',
          'meeting.number': '会议号',
          'meeting.pwd': '会议密码',
          'meeting.del': '删除会议',
          'meeting.del_prompt': '您确定删除该会议吗?',
          'message.gotcha': '重试',
          'meeting.join': '加入会议',
          'hint.meeting_numb': '请输入会议号',
          'hint.participant_name': '输入参会者名称',
          'opt.auto_connect_audio': '自动连接语音',
          'opt.keep_camera_off': '保持摄像头关闭',
          'join.participant_name': '参会者名称',
          'check.meeting_numb.not_empty': '会议号不能为空',
          'check.meeting_numb.format_error': '会议号格式无效',
          'check.participant_name.not_empty': '参会者名称不能为空',
          'snack-bar.message_warning': '提示',
          'meeting.pwd.required': '请输入会议密码',
          'meeting.pwd.error': '会议密码错误，请重试!',
          'message.app_fail_reconnect':
              '应用初始化失败，请确认网络正常，点击右侧【重试】, 若仍旧失败，请尝试重启应用！',
          'message.app_login_fail': '与服务器断开连接，请确保网络正常，重新登录',
          'message.app_login_fail_userpass_error': '登录失败，邮箱或密码错误！',
          'btn.continue': '继续',
          'title.profile': '个人资料',
          'title.login.fail': '登陆失败',
          'login.fail.otherLogin': '您的账号已在其他设备登陆',
          'profile.email': '账户',
          'profile.display_name': '显示名称',
          'profile.avatar': '头像',
          'profile.prompt_exit_app': '您确定要退出登录吗？',
          'logout.fail': '退出登录失败！',
          'language.settings': '语言设置',
          'language.zh': '简体中文',
          'language.en': '英语',
          'meeting.type_recurring': '周期会议',
          'meeting.schedule': '安排会议',
          'meeting.edit': '编辑会议',
          'hint.schedule.meeting_topic': '请输入会议主题',
          'meeting.schedule.start_date': '预约时间',
          'meeting.schedule.duration': '会议时长',
          'meeting.schedule.timepicker': '选择会议时长',
          'meeting.schedule.pwd': '会议密码',
          'opt.schedule.host_enable_video': '主持人视频开启',
          'opt.schedule.participant_enable_video': '参会者视频开启',
          'opt.schedule.jbh_enable': '允许参会者随时加会',
          'opt.schedule.waiting_room_enable': '启用等候室',
          'meeting.schedule.timezone': '时区',
          'opt.schedule.requirePwd': '需要密码',
          'meeting.pwd.invalid': '会议密码无效',
          'schedule.default_meeting_topic': ' 的会议',
          'my.schedule_meeting_topic': '我的预约会议',
          'meeting.clear_history': '清除历史记录',
        },
        'en_US': {
          'client.version': 'Version ',
          'login.name': '锐安会议',
          'login.email': 'Email',
          'login.email.hint': 'Please input email',
          'login.pwd': 'Password',
          'login.pwd.hint': 'Please input password',
          'login.btn': 'Login',
          'login.welcome': 'Welcome Aboard',
          'login.back_to_login': 'Back to Login',
          'check.enter.valid.email': 'Please enter a valid email',
          'check.enter.pwd.required': 'Password is required',
          'login.fail': 'Login failed',
          'login.success': 'Login success, redirecting...',
          'nav.meeting': 'Meeting',
          'nav.profile': 'Profile',
          'title.meeting': 'Meeting',
          'btn.confirm': 'Yes',
          'btn.cancel': 'No',
          'btn.new_meeting': 'New Meeting',
          'btn.join_meeting': 'Join',
          'btn.join_meeting_without_login': 'Join Meeting',
          'btn.schedule_meeting': 'Schedule',
          'btn.del_meeting': 'Delete',
          'btn.exit_app': 'Exit',
          'text.meeting_numb': 'Meeting ID: ',
          'title.start_meeting': 'Start Meeting',
          'title.schedule_meeting.submit': 'Schedule Meeting',
          'title.edit_meeting.submit': 'Edit Meeting',
          'confirm.schedule_meeting.submit': 'Are you sure to submit request?',
          'switch.enable_video': 'Enable Video',
          'switch.use_pmi': 'Use PMI',
          'btn.start_meeting': 'Start Meeting',
          'btn.edit_meeting': 'Edit Meeting',
          'list.no_schedule_meeting': 'No available meetings ',
          'toast.init_app_failed': 'Init service failed!',
          'toast.init_app_success': 'Init service success!',
          'toast.auto_login_success': 'User auto login success',
          'toast.auto_login_failed': 'User auto login failed',
          'toast.schedule_meeting.submit.fail': 'Schedule meeting failed!',
          'toast.edit_meeting.submit.fail': 'Edit meeting failed',
          'toast.get_meeting.failed': 'Get meeting failed',
          'toast.schedule_meeting.submit.success': 'Schedule meeting success!',
          'toast.edit_meeting.submit.success': 'Edit meeting success',
          'toast.delete_meeting.failed': 'Delete meeting failed',
          'toast.login_must_agree_disclaimer':
              'Please agree user policy and privacy',
          'toast.connection_error': 'Warning: Connection unavailable!',
          'meeting.detail': 'Meeting Detail',
          'text.meeting_topic': 'Topic',
          'meeting.start_time': 'Start Time',
          'meeting.number': 'Meeting Number',
          'meeting.pwd': 'Password',
          'meeting.del': 'Delete',
          'message.gotcha': 'Retry',
          'message.app_fail_reconnect':
              'Application init failed, click [Retry] on right side, if still not working, please restart your app!',
          'meeting.del_prompt': 'Are you sure to delete this meeting?',
          'meeting.join': 'Join meeting',
          'hint.meeting_numb': 'Please input meeting number',
          'hint.participant_name': 'Please input participant name',
          'opt.auto_connect_audio': 'Auto connect audio',
          'opt.keep_camera_off': 'Keep camera off',
          'join.participant_name': 'Participant name',
          'check.meeting_numb.not_empty': 'Meeting number is required',
          'check.meeting_numb.format_error': 'Meeting number must be numeric',
          'check.participant_name.not_empty': 'Participant name is required',
          'snack-bar.message_warning': 'Warn',
          'meeting.pwd.required': 'Please input password',
          'meeting.pwd.error': 'Password error, retry please!',
          'message.app_login_fail':
              'Disconnected from the server, please make sure the network is working properly, log in again',
          'message.app_login_fail_userpass_error':
              'Email or Password is not correct!',
          'btn.continue': 'Continue',
          'title.profile': 'Profile',
          'title.login.fail': 'Login Failed',
          'login.fail.otherLogin':
              'Your account has been logged-In on another device',
          'profile.email': 'Account',
          'profile.display_name': 'Display Name',
          'profile.avatar': 'Avatar',
          'profile.prompt_exit_app': 'Are you sure to logout?',
          'logout.fail': 'Logout failed',
          'language.settings': 'Language',
          'language.zh': 'Chinese',
          'language.en': 'English',
          'meeting.type_recurring': 'Recurring',
          'meeting.schedule': 'Schedule Meeting',
          'meeting.edit': 'Edit Meeting',
          'hint.schedule.meeting_topic': 'Input meeting topic',
          'meeting.schedule.start_date': 'Start',
          'meeting.schedule.duration': 'Duration',
          'meeting.schedule.timepicker': 'Pick Meeting Duration',
          'meeting.schedule.pwd': 'Password',
          'opt.schedule.host_enable_video': 'Host enable video',
          'opt.schedule.participant_enable_video': 'Participant enable video',
          'opt.schedule.jbh_enable': 'Enable participants join before host',
          'opt.schedule.waiting_room_enable': 'Enable waiting room',
          'meeting.schedule.timezone': 'TimeZone',
          'opt.schedule.requirePwd': 'Require password',
          'meeting.pwd.invalid': 'Invalid password',
          'schedule.default_meeting_topic': ' \'s meeting',
          'my.schedule_meeting_topic': 'My schedule meeting',
          'meeting.clear_history': 'Clear history',
        }
      };
}
