*** Settings ***
Documentation     Sample test case performing a reboot via SSH
Library           SSHLibrary
Suite Setup       Setup SSH connection

*** Test Cases ***
Test device reboot
    [Documentation]    Tests rebooting the device via SSH
    [Tags]             ssh-test
    ${ssh_conn}        Open Connection    ${HOSTNAME}    port=${PORT}
    ${login}           Login    ${USERNAME}    ${PASSWORD}
    Reboot
    Sleep              30s
    ${ping_output}     Execute Command    ping -c 3 ${HOSTNAME}
    Should Contain     ${ping_output.stdout}    3 received
    Close Connection

*** Keywords ***
Setup SSH connection
    [Documentation]    Sets up SSH connection to the device
    [Tags]             ssh-test
    Open Connection    ${HOSTNAME}    port=${PORT}
    Login              ${USERNAME}    ${PASSWORD}
    [Teardown]         Close Connection

Reboot
    [Documentation]    Performs device reboot via SSH
    [Tags]             ssh-test
    Execute Command    sudo reboot
    Wait Until Keyword Succeeds    30s    5s    Ping Device

Ping Device
    [Documentation]    Pings the device to check if it is available
    [Tags]             ssh-test
    ${ping_output}     Execute Command    ping -c 3 ${HOSTNAME}
    Should Contain     ${ping_output.stdout}    3 received
