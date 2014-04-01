class Employee
  attr_accessor :boss
  attr_reader :salary
  def initialize(name, title, salary, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @bonus = @salary * multiplier
  end
end

class Manager < Employee
  def initialize(name, title, salary, boss = nil)
    super
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
    employee.boss = self
  end

  def employees_salaries
    @employees.inject do |a, employee|
      a + employee.salary
    end
  end

  def bonus(multiplier)
    @bonus_base = 0
    @employees.each do |employee|
      @bonus_base += employee.salary
      @bonus_base += employee.employees_salaries if employee.is_a?(Manager)
    end
    @bonus_base * multiplier
  end
end

boss = Manager.new("Ned", "Boss", 100000000)
a = Employee.new("Breakfast", "Worker", 50000)
b = Employee.new("Gizmo", "Worker", 50000)
boss.add_employee(a)
boss.add_employee(b)

p boss.bonus(0.15)