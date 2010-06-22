# File: command_line_control.feature

Feature: Command line control
  In order to control the program
  As a command line user
  I want to be able to have a CLI control interface

  Scenario: Show CLI help screen by calling with -h or --help
    Given I am executing the program on the command line
    And I provide the '-h' or '--help' switch as a command line argument
    When I execute the program
    Then I should see in the first line "Usage: Battery.rb [options]"

  Scenario: Show the full design capacity of the battery with '-d' or '--design'
    Given I am executing the program on the command line
    And I provide the '-d' or '--design' switch as a command line argument (with -vr for value and raw)
    When I execute the program with this design switch
    Then I should see as a return value an integer number representing the full design capacity of the battery

  Scenario: Show the full capacity of the battery with '-f' or '--full'
    Given I am executing the program on the command line
    And I provide the '-f' or '--full' switch as a command line argument (with -vr for value and raw)
    When I execute the program with the full capacity switch
    Then I should see as a return value an integer number representing the full capacity of the battery

  Scenario: Show the current capacity of the battery with '-n' or '--now'
    Given I am executing the program on the command line
    And I provide the '-n' or '--now' switch as a command line argument (with -vr for value and raw)
    When I execute the program with the current capacity switch
    Then I should see as a return value an integer number representing the current capacity of the battery

  Scenario: Show the current capacity of the battery with '-n' and '-p' or '--percent' in Percent in respect of the full capacity
    Given I am executing the program on the command line
    And I provide the '-n' or '--now' switch together with '-p' or '--percent' as a command line argument (with -r for raw)
    When I execute the program with the current capacity switch in percent mode
    Then I should see as a return value an three digit integer number or smaller representing the current capacity of the battery in percentage
    When I provide the '-f' switch together with '-p' (and -r for raw)
    When I execute the program with the full capacity switch in percent mode
    Then I should see as a return value of "100"
    When I provide the '-d' switch together with '-p' (and -r for raw)
    When I execute the program with the design capacity switch in percent mode
    Then I should see a return value of "100" or greater

  Scenario: Show a pretty formatting in bar format with '-b' or '--bar' in respect to full charge when battery is 100 Percent
    Given I am executing the program on the command line
    And I provide the '-b' and '-f' switch as a command line argument
    When I execute the program with the current bar graph switch
    Then I should see a nice bargraph formatting like this
      """
[ |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ]
      """

  Scenario: Show a pretty formatting in bar format with '-b' or '--bar' in respect to full charge when battery is 100 Percent in color with '-c'
    Given I am executing the program on the command line
    And I provide the '-b', '-f' and '-c' switch as a command line argument
    When I execute the program with the current bar graph switch in color mode
    Then I should see a nice bargraph formatting like this with colors
      """
[ e[1;32m||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||e[0m ]
      """


