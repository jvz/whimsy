#
# Approve/Unapprove a report
#
class Approve < Vue
  def initialize
    @disabled = false
  end

  # render a single button
  def render
    _button.btn.btn_primary request, onClick: self.click, disabled: @disabled
  end

  # set request (and button text) depending on whether or not the
  # not this items was previously approved
  def request
    if Pending.approved.include? @@item.attach
      'unapprove'
    elsif Pending.unapproved.include? @@item.attach
      'approve'
    elsif @@item.approved and @@item.approved.include? Server.initials
      'unapprove'
    else
      'approve'
    end
  end

  # when button is clicked, send request
  def click(event)
    data = {
      agenda: Agenda.file,
      initials: Server.initials,
      attach: @@item.attach,
      request: request
    }

    @disabled = true
    post 'approve', data do |pending|
      @disabled = false
      Pending.load pending
    end
  end
end
