//Kevin Valenzuela

use books;

db.books.insert({ isbn: "9780134685991", title: "Effective Java", author: "Joshua Block", date: {year: "2001", month: "December"}, pages: 1002 })
db.books.insert({ isbn: "9780262033848", title: "Introduction to Algorithsm", author: "Thomas Cormen", date: {year: "1989", month: "January"}, pages: 1314 })
db.books.insert({ isbn: "9780577392794", title: "Operating Sytem Concepts", author: "Abi Silberschatz", date: {year: "1982", month: "July"}, pages: 184 })
db.books.insert({ isbn: "9780132350884", title: "Clean Code", author: "Robert Cecil Martin", date: {year: "2008", month: "August"}, pages: 464 })
db.books.insert({ isbn: "9781133187790", title: "Theory Of Computation", author: "Michael Sipser", date: {year: "1997", month: "May"}, pages: 482 })

db.books.find();

db.books.find({}, { _id: 0, title: 1});

db.books.find({ author: "Joshua Block"});

db.books.find({ "date.year" : "2008" });

db.books.find({ pages:{ $gte: 100, $lt: 500 }});


