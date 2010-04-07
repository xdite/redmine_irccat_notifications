class NotifierHook < Redmine::Hook::Listener

  def controller_issues_new_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @user = @issue.author
    speak "#{@user.lastname} #{@user.firstname}  created issue 「#{@issue.subject}」. Comment: 「#{truncate_words(@issue.description)}」 http://#{Setting.host_name}/issues/#{@issue.id}"
  end
  
  def controller_issues_edit_after_save(context = { })
    @project = context[:project]
    @issue = context[:issue]
    @journal = context[:journal]
    @user = @journal.user
    speak "#{@user.lastname} #{@user.firstname}  edited issue 「#{@issue.subject}」. Comment: 「#{truncate_words(@journal.notes)}」.  http://#{Setting.host_name}/issues/#{@issue.id}"
  end

  def controller_messages_new_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    speak "#{@user.lastname} #{@user.firstname}  wrote a new message 「#{@message.subject}」 on #{@project.name}: 「#{truncate_words(@message.content)}」. http://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_messages_reply_after_save(context = { })
    @project = context[:project]
    @message = context[:message]
    @user = @message.author
    speak "#{@user.lastname} #{@user.firstname}  replied a message 「#{@message.subject}」 on #{@project.name}: 「#{truncate_words(@message.content)}」. http://#{Setting.host_name}/boards/#{@message.board.id}/topics/#{@message.root.id}#message-#{@message.id}"
  end
  
  def controller_wiki_edit_after_save(context = { })
    @project = context[:project]
    @page = context[:page]
    @user = @page.content.author
    speak "#{@user.lastname} #{@user.firstname}  edited the wiki 「#{@page.pretty_title}」 on #{@project.name}. http://#{Setting.host_name}/projects/#{@project.identifier}/wiki/#{@page.title}"
  end

private

  def speak(message)
    system("echo -n #{message} | nc localhost 5678")

  end

  def truncate_words(text, length = 20, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
