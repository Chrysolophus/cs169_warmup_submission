require 'test_helper'

$SUCCESS = 1
$ERR_BAD_CREDENTIALS = -1
$ERR_USER_EXISTS = -2
$ERR_BAD_USERNAME = -3
$ERR_BAD_PASSWORD = -4


class UsersTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
    test "TESTAPI_resetFixture" do
        Users.TESTAPI_resetFixture
        result = Users.TESTAPI_resetFixture
        assert result == $SUCCESS
    end

    test "add legal user" do
        Users.TESTAPI_resetFixture
        result = Users.add("test","test")
        assert result == $SUCCESS, "Adding legal user failed"
    end

    test "add blank user" do
        Users.TESTAPI_resetFixture
        result = Users.add("","test")
        assert result ==  $ERR_BAD_USERNAME, "Blank username added! Username checking failed!"
    end

    test "add overly-long user" do
        Users.TESTAPI_resetFixture
        result = Users.add("t"*129,"test")
        assert result ==  $ERR_BAD_USERNAME, "Illegal username added! Username checking failed!"
    end

    test "add blank password" do
        Users.TESTAPI_resetFixture
        result = Users.add("test","")
        assert result ==  $ERR_BAD_PASSWORD, "Blank password added! Password checking failed!"
    end

    test "add overly-long password" do
        Users.TESTAPI_resetFixture
        result = Users.add("test","t"*129)
        assert result ==  $ERR_BAD_PASSWORD, "Illegal password added! Password checking failed!"
    end

    test "add duplicate user" do
        Users.TESTAPI_resetFixture
        assert Users.add("test","test") == $SUCCESS
        assert Users.add("test","testy") == $ERR_USER_EXISTS
    end

    test "login non-existent user" do
        Users.TESTAPI_resetFixture
        assert Users.login("test","test") == $ERR_BAD_CREDENTIALS
    end

    test "add users with shared, but legal passwords" do
        Users.TESTAPI_resetFixture
        assert Users.add("test1","test") == $SUCCESS
        assert Users.add("test2","test") == $SUCCESS
    end

    test "test login count incrementing" do
        Users.TESTAPI_resetFixture
        assert Users.add("test", "test") == 1
        assert Users.login("test", "test") == 2
    end

end
