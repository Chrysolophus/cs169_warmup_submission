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
        # We can get away with this because 1 is the only successful error code
        returnJSON = {:errCode => returncode}
        errJSON = {:errCode => $SUCCESS, :count => returncode}
        
        if returncode < 1
            render :json => returnJSON
        else
            render :json => errJSON
        end
    end
    # LOGIN
    def login
        # Take the user as a parameter, along with password
        myuser = params[:user]
        mypassword = params[:password]
        # The return value of the method call login()
        returncode = Users.login(myuser, mypassword)
        returnJSON = {:errCode => returncode}
        errJSON = {:errCode => $SUCCESS, :count => returncode}
        
        if returncode < 1
            render :json => returnJSON
        else
            render :json => errJSON
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
            utOutput = `ruby -Itest test/unit/users_test.rb`
            utValue = utOutput.split(/\r?\n/)
            
            failedUnitTests = utValue[-1].split(",")[2]
            totalUnitTests = utValue[-1].split(",")[0]
            
            totalUnitTests = Integer(totalUnitTests.scan(/\d+/)[0])
            failedUnitTests = Integer(failedUnitTests.scan(/\d+/)[0])
            
            
            outputJSON = {:totalTests => totalUnitTests, :nrFailed => failedUnitTests, :output => utOutput}
            errorJSON = {:output => "ERROR OCCURED"}
            
            render :json => outputJSON
            
            rescue Exception
            render :json => errorJSON
            
        end
    end
end
