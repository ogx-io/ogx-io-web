class Elite::CategoryPolicy < ApplicationPolicy

  def update?

  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
