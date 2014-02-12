## The following variables are globally scoped so as to make them public to the view and controller

## The success return code
$SUCCESS               =   1
## Cannot find the user/password pair in the database (for login only)
$ERR_BAD_CREDENTIALS   =  -1
## trying to add a user that already exists (for add only)
$ERR_USER_EXISTS       =  -2
## invalid user name (empty or longer than MAX_USERNAME_LENGTH) (for add, or login)
$ERR_BAD_USERNAME      =  -3
## invalid password name (longer than MAX_PASSWORD_LENGTH) (for add)
$ERR_BAD_PASSWORD      =  -4
## The maximum length of user name
$MAX_USERNAME_LENGTH = 128
## The maximum length of the passwords
$MAX_PASSWORD_LENGTH = 128

class Users < ActiveRecord::Base
    
    ## To perform equivalent of
    #@param user: (string) the username
    #@param password: (string) the password
    
    attr_accessible :username, :password, :count, :remember_token
    
    def self.login(myuser, mypassword)
    
        #This function checks the user/password in the database.
        loginattempt = where("username = ? AND password = ?", myuser, mypassword)
        if loginattempt.length > 0
            curuser = loginattempt.first
            #* On success, the function updates the count of logins in the database.
            curuser.count = curuser.count + 1
            curuser.save
            #* On success the result is either the number of logins (including this one) (>= 1)
            return curuser.count
        else
            #* On failure the result is an error code (< 0) from the list below
            #* ERR_BAD_CREDENTIALS
            return $ERR_BAD_CREDENTIALS
        end
    end


    def self.add(myuser, mypassword)

        #This function checks that the user does not exists, the user name is not empty. (the password may be empty).
        #* On failure the result is an error code (<0) from the list below
        #* ERR_BAD_USERNAME, ERR_BAD_PASSWORD, ERR_USER_EXISTS
        if Users.exists?(:username => myuser)
                return $ERR_USER_EXISTS
        elsif myuser.to_s == "" or myuser.length > 128
            return $ERR_BAD_USERNAME
        elsif mypassword.to_s == "" or mypassword.length > 128
            return $ERR_BAD_PASSWORD
        else
            #@param user: (string) the username
            #@param password: (string) the password
            #* On success the function adds a row to the DB, with the count initialized to 1
            curuser = Users.new(:username => myuser, :password => mypassword, :count => 1)
            curuser.save
            #* On success the result is the count of logins
            return curuser.count
        end
    end

    def self.TESTAPI_resetFixture
        #This function is used only for testing, and should clear the database of all rows.
        Users.delete_all
         #It should always return SUCCESS (1)
        return $SUCCESS
    end
end
