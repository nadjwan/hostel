<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
<link rel="stylesheet" href="login.css">
</head>
<body>
	<div class="wrapper">
		<div class="title">Login Form</div>
		<form action="LoginServlet" method="post">
			<div class="field">
				<input type="text" name="email" required> <label>Email Address</label>
			</div>
			<div class="field">
				<input type="password" name="pass" required> <label>Password</label>
			</div>
			<div class="content">
				<!--
				<div class="checkbox">
					<input type="checkbox" id="remember-me"> <label
						for="remember-me">Remember me</label>
				</div>
				-->
				<div class="pass-link">
					<a href="#">Forgot password?</a>
				</div>
			</div>
			<div class="field">
				<input type="submit" value="Login">
			</div>
			<div class="signup-link">
				Not a member? <a href="registerPage.html">Signup now</a>
			</div>
		</form>
	</div>
</body>
</html>