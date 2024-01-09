class Cookies::SwitchComponent < ApplicationComponent
  attr_reader :checked, :disabled, :name, :label

  def initialize(name, label, checked = false, disabled = false)
    @name = name
    @label = label
    @checked = checked
    @disabled = disabled
  end

  private

    def checked?
      checked == true
    end

    def disabled?
      disabled == true
    end
end
