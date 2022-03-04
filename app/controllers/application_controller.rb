class ApplicationController < ActionController::Base
   # ApplicationControllerにSessionヘルパーモジュールを組み込むことで全てのcontrollerでSessionヘルパーモジュールを使用できる。
  include SessionsHelper
end