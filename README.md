# ChatView

This is not fully completed library. This is just test project. This will be updated by client's requirements. I will update more later.

# Installation

Add ChatView folder to destination project.

# Usage

let chatView = ChatsView()
chatView.samples = samples
chatView.startDate = Date().subtractingDays(20)
chatView.endDate = Date().addingDays(20)
self.view.addSubview(chatsView)

## Variables
extraSpace: top, bottom space
fieldSpace: default space value of between days
brixWidth; left brix view width
tempWidth: right temp view width
