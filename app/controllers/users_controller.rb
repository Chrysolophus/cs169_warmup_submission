class UsersController < ApplicationController
    
    # WEBPAGE
    def webpage
        @users = Users.all
        respond_to :html
    end
    # ADD
    def add
        # Take the user as a parameter, along with password
        myuser = params[:user]
        mypassword = params[:password]
        # The return value of the method call add()
        returncode = Users.add(myuser, mypassword)
        # Make a JSON for error and successful execution
        errJSON = {:errCode => returncode}
        returnJSON = {:errCode => $SUCCESS, :count => returncode}
        
        # We can get away with this because 1 is the only successful error code
        if returncode < 1
            render :json => errJSON
        else
            render :json => returnJSON
        end
    end
    # LOGIN
    def login
        # Take the user as a parameter, along with password
        myuser = params[:user]
        mypassword = params[:password]
        # The return value of the method call login()
        returncode = Users.login(myuser, mypassword)
        
        errJSON = {:errCode => returncode}
        returnJSON = {:errCode => $SUCCESS, :count => returncode}
        
        if returncode < 1
            render :json => errJSON
        else
            render :json => returnJSON
        end
    end
    # resetFixture
    def resetFixture
        # The return value of the method call TESTAPI_resetFixture()
        returncode = Users.TESTAPI_resetFixture
        returnJSON = {:errCode => returncode}
        render :json => returnJSON
    end
    # unitTests
    def unitTests
        begin
            # utOutput is a ruby file
            utOutput = `ruby -Itest test/unit/users_test.rb`
            # Split file into an array of rows based on page lines
            utValue = utOutput.split(/\r?\n/)
            
            # In English, these two variables take the last line of the ruby file,
            # split along "," characters, and return 3rd and 1st elements
            # respectively as integers
            
            # For reference, the last line of the file looks like:
            # "10 tests, 13 assertions, 0 failures, 0 errors, 0 skips"
            
            failedUnitTests = Integer(utValue[-1].split(",")[2].scan(/\d+/)[0])
            totalUnitTests = Integer(utValue[-1].split(",")[0].scan(/\d+/)[0])
            
            # Make 2 JSONs, one containing default output, one for when something
            # goes amiss during runtime (i.e. 500 error)
            outputJSON = {:totalTests => totalUnitTests, :nrFailed => failedUnitTests, :output => utOutput}
            errorJSON = {:output => "ERROR OCCURED"}
            
            render :json => outputJSON
            
            rescue Exception
            render :json => errorJSON
            
        end
    end
end
