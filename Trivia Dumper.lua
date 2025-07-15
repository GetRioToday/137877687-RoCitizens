local CurrentClass = workspace.WorkEnvironments.School_Student.EnvironmentHandler.CurrentClass;
local Trivia = {}

local Env = getgenv()
local setclipboard = Env.setclipboard;

local function Scrape(Name: string)
	local Class = workspace.WorkEnvironments.School_Student.Classrooms[Name];
	local Question = Class:WaitForChild("Boards"):WaitForChild("Chalkboard"):WaitForChild("Board"):WaitForChild("TriviaGame"):WaitForChild("Question"):WaitForChild("Question");
	local Answer = Class:WaitForChild("Boards"):WaitForChild("Chalkboard"):WaitForChild("Board"):WaitForChild("TriviaGame"):WaitForChild("Result"):WaitForChild("Answer");

	while Name == CurrentClass.Value do
		warn"waiting for answer"
		Answer:GetPropertyChangedSignal("Text"):Wait()
		warn"got"

		Trivia[Name] = Trivia[Name] or {}
		Trivia[Name][Question.Text] = string.sub(Answer.Text, 9);

		print("For", Name, "class, the question was \"" .. Question.Text .. "\" and answer was:", Trivia[Name][Question.Text])
		task.wait(15) -- explanation + answer show screen delay
	end
end

Env.Work = true; -- execute "Work = false" as a script to stop scraping & copy JSON results to your clipboard
Env.Trivia = Trivia; -- put into the global environment, so you can access the Trivia database just by typing "Trivia" in any of your scripts

while Env.Work do
	print("Scraping", CurrentClass.Value)
	Scrape(CurrentClass.Value)
	print("Finished!")
end

setclipboard(game:GetService("HttpService"):JSONEncode(Trivia))
