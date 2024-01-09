class Cookies::SwitchComponent < ApplicationComponent
  attr_reader :checked, :disabled, :name, :label, :description

  def initialize(name, label:, description: , checked: false, disabled: false)
    @name = name
    @label = label
    @checked = checked
    @disabled = disabled
    @description = description
  end

  private

    def checked?
      checked == true
    end

    def disabled?
      disabled == true
    end
end
