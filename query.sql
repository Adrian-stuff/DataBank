-- Create the Database
CREATE DATABASE AstralArchiveDB;
GO
USE AstralArchiveDB;
GO

-- 1. Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL
);

-- 2. Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Nationality NVARCHAR(50),
    BirthYear INT
);

-- 3. Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    ISBN NVARCHAR(20) UNIQUE,
    Title NVARCHAR(255) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    Publisher NVARCHAR(100),
    PublishYear INT,
    Edition INT DEFAULT 1,
    TotalCopies INT DEFAULT 1
);

-- 4. Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(255) UNIQUE,
    Password NVARCHAR(255),
    Phone NVARCHAR(20),
    MembershipType NVARCHAR(50), -- Student, Faculty, Public
    JoinDate DATE DEFAULT GETDATE(),
    ExpiryDate DATE,
    IsActive BIT DEFAULT 1,
    Address NVARCHAR(MAX)
);

-- 5. Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(255) UNIQUE,
    Role NVARCHAR(50),
    HireDate DATE
);

-- 6. BookAuthors Table (N:M bridge — one book can have multiple authors, one author can write multiple books)
CREATE TABLE BookAuthors (
    BookAuthorID INT PRIMARY KEY IDENTITY(1,1),
    BookID   INT NOT NULL FOREIGN KEY REFERENCES Books(BookID)   ON DELETE CASCADE,
    AuthorID INT NOT NULL FOREIGN KEY REFERENCES Authors(AuthorID) ON DELETE CASCADE,
    Role     NVARCHAR(50) DEFAULT 'Primary',   -- Primary, Co-Author, Editor, Contributor
    CONSTRAINT UQ_BookAuthor UNIQUE (BookID, AuthorID)
);

-- 7. Loans Table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    LoanDate DATE DEFAULT GETDATE(),
    DueDate DATE,
    ReturnDate DATE NULL,
    Status NVARCHAR(20) DEFAULT 'Active' -- Active, Overdue, Returned
);

-- 8. Reservations Table
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    ReservationDate DATE DEFAULT GETDATE(),
    ExpiryDate DATE,
    Status NVARCHAR(20) DEFAULT 'Pending' -- Pending, Fulfilled, Cancelled
);

-- 9. Fines Table
CREATE TABLE Fines (
    FineID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT FOREIGN KEY REFERENCES Loans(LoanID),
    Amount DECIMAL(10, 2),
    Reason NVARCHAR(255),
    IsPaid BIT DEFAULT 0,
    PaidDate DATE NULL
);


USE AstralArchiveDB;
GO

-- 1. POPULATE CATEGORIES (20 Records)
INSERT INTO Categories (CategoryName) VALUES 
('Fiction'), ('Non-Fiction'), ('Science'), ('Technology'), ('History'),
('Philosophy'), ('Mathematics'), ('Business'), ('Self-Help'), ('Children'),
('Mystery'), ('Biography'), ('Poetry'), ('Art'), ('Music'),
('Travel'), ('Health'), ('Religion'), ('Politics'), ('Science Fiction');

-- 2. POPULATE AUTHORS (20 Records)
INSERT INTO Authors (FirstName, LastName, Nationality, BirthYear) VALUES 
('George', 'Orwell', 'British', 1903), ('J.K.', 'Rowling', 'British', 1965),
('Stephen', 'Hawking', 'British', 1942), ('Yuval Noah', 'Harari', 'Israeli', 1976),
('J.R.R.', 'Tolkien', 'British', 1892), ('Himeko', 'Murata', 'Japanese', 1995),
('Welt', 'Yang', 'German', 1950), ('Dan', 'Heng', 'Chinese', 1998),
('March', 'Seventh', 'Unknown', 2005), ('Kafka', 'Stelle', 'Italian', 1988),
('Isaac', 'Asimov', 'Russian', 1920), ('Agatha', 'Christie', 'British', 1890),
('Ernest', 'Hemingway', 'American', 1899), ('Mark', 'Twain', 'American', 1835),
('Fyodor', 'Dostoevsky', 'Russian', 1821), ('Leo', 'Tolstoy', 'Russian', 1828),
('Virginia', 'Woolf', 'British', 1882), ('James', 'Joyce', 'Irish', 1882),
('Gabriel', 'Garcia Marquez', 'Colombian', 1927), ('Haruki', 'Murakami', 'Japanese', 1949);

-- 3. POPULATE BOOKS (20 Records)
-- Assumes AuthorIDs 1-20 and CategoryIDs 1-20 exist from above
INSERT INTO Books (ISBN, Title, CategoryID, AuthorID, Publisher, PublishYear, TotalCopies) VALUES
('978-0451524935', '1984', 1, 1, 'Signet Classic', 1949, 5),
('978-0439708180', 'Harry Potter', 1, 2, 'Scholastic', 1997, 8),
('978-0553380163', 'A Brief History of Time', 3, 3, 'Bantam Books', 1988, 3),
('978-0062316097', 'Sapiens', 5, 4, 'Harper', 2011, 4),
('978-0544003415', 'The Lord of the Rings', 20, 5, 'Mariner Books', 1954, 6),
('978-1234567890', 'Star Rail Chronicles', 4, 6, 'Astral Press', 2023, 2),
('978-0987654321', 'Void Archives', 6, 7, 'St. Fountain', 2021, 1),
('978-1111222233', 'Cloud Knight Records', 5, 8, 'Luofu Publishing', 2022, 5),
('978-4444555566', 'Memories of Six Phases', 11, 9, 'Express Media', 2024, 3),
('978-7777888899', 'The Stellaron Crisis', 20, 10, 'Hunter House', 2020, 2),
('978-0553293357', 'Foundation', 20, 11, 'Spectra', 1951, 4),
('978-0007119318', 'Murder on the Orient Express', 11, 12, 'HarperCollins', 1934, 7),
('978-0684801223', 'The Old Man and the Sea', 1, 13, 'Scribner', 1952, 4),
('978-0143039433', 'The Adventures of Tom Sawyer', 1, 14, 'Penguin Classics', 1876, 5),
('978-0140449136', 'Crime and Punishment', 1, 15, 'Penguin', 1866, 3),
('978-0140447934', 'War and Peace', 1, 16, 'Penguin Classics', 1869, 2),
('978-0156628709', 'Mrs Dalloway', 1, 17, 'Harcourt', 1925, 4),
('978-0141182803', 'Ulysses', 1, 18, 'Penguin', 1922, 2),
('978-0060883287', 'One Hundred Years of Solitude', 1, 19, 'Harper Perennial', 1967, 5),
('978-1400079278', 'Kafka on the Shore', 1, 20, 'Vintage', 2002, 4);

-- 4. POPULATE MEMBERS (40 Records)
INSERT INTO Members (FirstName, LastName, Email, Password, MembershipType, JoinDate, IsActive) VALUES
('Jolina', 'Acdan', 'jolinamaejose.acdan@plv.edu.ph', 'pass3', 'Student', '2025-01-10', 1),
('Justine', 'Alamer', 'justinedesengano.alamer@plv.edu.ph', 'pass4', 'Student', '2025-01-10', 1),
('Neille', 'Alberto', 'neillearghie.alberto@plv.edu.ph', 'pass5', 'Student', '2025-01-10', 1),
('Vince', 'Atalio', 'vinceehrl.atalio@plv.edu.ph', 'pass6', 'Student', '2025-01-10', 1),
('Carl', 'Asuliz', 'carljoshua.asuliz@plv.edu.ph', 'pass7', 'Student', '2025-01-10', 1),
('Jerriel', 'Barcoma', 'jerriel.barcoma@plv.edu.ph', 'pass8', 'Student', '2025-01-10', 1),
('John', 'Berba', 'johnandrei.berba@plv.edu.ph', 'pass9', 'Student', '2025-01-10', 1),
('Jedidiah', 'Bernardo', 'jedidiahdaniel.bernardo@plv.edu.ph', 'pass10', 'Student', '2025-01-10', 1),
('Serg', 'Bravo', 'sergraye.bravo@plv.edu.ph', 'pass11', 'Student', '2025-01-10', 1),
('Justin', 'Canilao', 'justinrain.canilao@plv.edu.ph', 'pass12', 'Student', '2025-01-10', 1),
('Lord', 'Casimiro', 'lordrandall.casimiro@plv.edu.ph', 'pass13', 'Student', '2025-01-10', 1),
('Phoebe', 'Damaso', 'phoebekate.damaso@plv.edu.ph', 'pass14', 'Student', '2025-01-10', 1),
('Rafael', 'Danganan', 'rafaelmariano.danganan@plv.edu.ph', 'pass15', 'Student', '2025-01-10', 1),
('Adrian', 'De Vera', 'adrian.devera@plv.edu.ph', 'pass16', 'Student', '2025-01-10', 1),
('David', 'Dela Cruz', 'davidalan.delacruz@plv.edu.ph', 'pass17', 'Student', '2025-01-10', 1),
('Christian', 'Deyro', 'christianluis.deyro@plv.edu.ph', 'pass18', 'Student', '2025-01-10', 1),
('Carl', 'Espino', 'carljustin.espino@plv.edu.ph', 'pass19', 'Student', '2025-01-10', 1),
('Jan', 'Espiritu', 'janmarc.espiritu@plv.edu.ph', 'pass20', 'Student', '2025-01-10', 1),
('John', 'Gavino', 'johnmark.gavino@plv.edu.ph', 'pass21', 'Student', '2025-01-10', 1),
('Mig', 'Juliano', 'migcedrik.juliano@plv.edu.ph', 'pass22', 'Student', '2025-01-10', 1),
-- Records 21-40
('Lawrence', 'Literatus', 'lawrence.literatus@plv.edu.ph', 'pass23', 'Student', '2025-01-10', 1),
('Reymark', 'Magsipoc', 'reymark.magsipoc@plv.edu.ph', 'pass24', 'Student', '2025-01-10', 1),
('Sean', 'Malaque', 'seankendrick.malaque@plv.edu.ph', 'pass25', 'Student', '2025-01-10', 1),
('Raven', 'Malate', 'ravenshane.malate@plv.edu.ph', 'pass26', 'Student', '2025-01-10', 1),
('John', 'Mauricio', 'johncarl.mauricio@plv.edu.ph', 'pass27', 'Student', '2025-01-10', 1),
('Rafael', 'Medina', 'rafaelluis.medina@plv.edu.ph', 'pass28', 'Student', '2025-01-10', 1),
('Margarette', 'Mello', 'margarettejem.mello@plv.edu.ph', 'pass29', 'Student', '2025-01-10', 1),
('Jhaelord', 'Obugan', 'jhaelordlaurence.obugan@plv.edu.ph', 'pass30', 'Student', '2025-01-10', 1),
('Jester', 'Pascual', 'jestershane.pascual@plv.edu.ph', 'pass31', 'Student', '2025-01-10', 1),
('Rizalyn', 'Rapada', 'rizalyncristelle.rapada@plv.edu.ph', 'pass32', 'Student', '2025-01-10', 1),
('Robert', 'Ravillas', 'robertryan.ravillas@plv.edu.ph', 'pass33', 'Student', '2025-01-10', 1),
('Danya', 'Raymundo', 'danyacharisse.raymundo@plv.edu.ph', 'pass34', 'Student', '2025-01-10', 1),
('Jake', 'Rivera', 'jake.rivera@plv.edu.ph', 'pass35', 'Student', '2025-01-10', 1),
('Koby', 'Sales', 'konybrian.sales@plv.edu.ph', 'pass36', 'Student', '2025-01-10', 1),
('Irish', 'Sanchez', 'irish.sanchez@plv.edu.ph', 'pass37', 'Student', '2025-01-10', 1),
('Maxell', 'Sanchez', 'maxell.sanchez@plv.edu.ph', 'pass38', 'Student', '2025-01-10', 1),
('Kysiah', 'Sevilla', 'kysiah.samera@plv.edu.ph', 'pass39', 'Student', '2025-01-10', 1),
('John', 'Sinlao', 'johnrey.falcotelo@plv.edu.ph', 'pass40', 'Student', '2025-01-10', 1),
('Clarenz', 'Verga�o', 'clarenzvonkenneth.vergano@plv.edu.ph', 'pass41', 'Student', '2025-01-10', 1),
('Kenneth', 'Ycot', 'kenneth.priela@plv.edu.ph', 'pass42', 'Student', '2025-01-10', 1);

-- 5. POPULATE STAFF (20 Records)
INSERT INTO Staff (FirstName, LastName, Email, Role, HireDate) VALUES
('Caelus', 'Trailblazer', 'caelus@astral.edu', 'Admin', '2024-05-01'),
('Stelle', 'Trailblazer', 'stelle@astral.edu', 'Librarian', '2024-05-02'),
('Pom-Pom', 'Conductor', 'pompom@astral.edu', 'Manager', '2024-01-01'),
('Arlan', 'Security', 'arlan@herta.edu', 'IT Support', '2024-06-10'),
('Asta', 'Lead', 'asta@herta.edu', 'Head Librarian', '2024-06-11'),
('Robert', 'Staff1', 'r1@astral.edu', 'Librarian', '2025-01-01'),
('Susan', 'Staff2', 's2@astral.edu', 'Assistant', '2025-01-05'),
('Michael', 'Staff3', 'm3@astral.edu', 'Librarian', '2025-01-10'),
('Sarah', 'Staff4', 's4@astral.edu', 'Librarian', '2025-01-15'),
('David', 'Staff5', 'd5@astral.edu', 'Assistant', '2025-01-20'),
('Emma', 'Staff6', 'e6@astral.edu', 'Librarian', '2025-02-01'),
('James', 'Staff7', 'j7@astral.edu', 'Admin', '2025-02-05'),
('Linda', 'Staff8', 'l8@astral.edu', 'Assistant', '2025-02-10'),
('Joseph', 'Staff9', 'j9@astral.edu', 'Librarian', '2025-02-15'),
('Karen', 'Staff10', 'k10@astral.edu', 'Assistant', '2025-02-20'),
('Nancy', 'Staff11', 'n11@astral.edu', 'Librarian', '2025-03-01'),
('George', 'Staff12', 'g12@astral.edu', 'Assistant', '2025-03-05'),
('Betty', 'Staff13', 'b13@astral.edu', 'Librarian', '2025-03-10'),
('Donald', 'Staff14', 'd14@astral.edu', 'Assistant', '2025-03-15'),
('Dorothy', 'Staff15', 'd15@astral.edu', 'Librarian', '2025-03-20');

-- 6. POPULATE LOANS (20 Records)
INSERT INTO Loans (BookID, MemberID, StaffID, LoanDate, DueDate, Status) VALUES
(1, 1, 2, '2025-04-01', '2025-04-15', 'Returned'),
(2, 2, 2, '2025-04-05', '2025-04-19', 'Returned'),
(3, 3, 2, '2025-04-10', '2025-04-24', 'Active'),
(4, 4, 2, '2025-04-12', '2025-04-26', 'Active'),
(5, 5, 2, '2025-04-15', '2025-04-29', 'Active'),
(6, 6, 2, '2025-04-18', '2025-05-02', 'Returned'),
(7, 7, 2, '2025-04-20', '2025-05-04', 'Overdue'),
(8, 8, 2, '2025-04-22', '2025-05-06', 'Active'),
(9, 9, 2, '2025-04-25', '2025-05-09', 'Active'),
(10, 10, 2, '2025-04-28', '2025-05-12', 'Active'),
(11, 11, 2, '2025-05-01', '2025-05-15', 'Active'),
(12, 12, 2, '2025-05-02', '2025-05-16', 'Active'),
(13, 13, 2, '2025-05-03', '2025-05-17', 'Active'),
(14, 14, 2, '2025-05-04', '2025-05-18', 'Active'),
(15, 15, 2, '2025-05-05', '2025-05-19', 'Active'),
(16, 16, 2, '2025-05-05', '2025-05-19', 'Active'),
(17, 17, 2, '2025-05-06', '2025-05-20', 'Active'),
(18, 18, 2, '2025-05-06', '2025-05-20', 'Active'),
(19, 19, 2, '2025-05-07', '2025-05-21', 'Active'),
(20, 20, 2, '2025-05-07', '2025-05-21', 'Active');

-- 7. POPULATE RESERVATIONS (20 Records)
INSERT INTO Reservations (BookID, MemberID, ReservationDate, ExpiryDate, Status) VALUES
(1, 2, '2025-05-01', '2025-05-08', 'Pending'),
(5, 10, '2025-05-02', '2025-05-09', 'Pending'),
(3, 1, '2025-05-03', '2025-05-10', 'Pending'),
(8, 4, '2025-05-04', '2025-05-11', 'Pending'),
(12, 7, '2025-05-05', '2025-05-12', 'Pending'),
(15, 9, '2025-05-06', '2025-05-13', 'Pending'),
(18, 3, '2025-05-06', '2025-05-13', 'Pending'),
(20, 11, '2025-05-07', '2025-05-14', 'Pending'),
(2, 13, '2025-05-07', '2025-05-14', 'Pending'),
(4, 15, '2025-05-08', '2025-05-15', 'Pending'),
(6, 17, '2025-05-08', '2025-05-15', 'Pending'),
(7, 19, '2025-05-08', '2025-05-15', 'Pending'),
(9, 2, '2025-05-08', '2025-05-15', 'Pending'),
(11, 4, '2025-05-08', '2025-05-15', 'Pending'),
(13, 6, '2025-05-08', '2025-05-15', 'Pending'),
(14, 8, '2025-05-08', '2025-05-15', 'Pending'),
(16, 10, '2025-05-08', '2025-05-15', 'Pending'),
(17, 12, '2025-05-08', '2025-05-15', 'Pending'),
(19, 14, '2025-05-08', '2025-05-15', 'Pending'),
(10, 16, '2025-05-08', '2025-05-15', 'Pending');

-- 9. POPULATE FINES (20 Records)
INSERT INTO Fines (LoanID, Amount, Reason, IsPaid) VALUES
(1, 0.00, 'N/A', 1), (2, 5.00, 'Late return', 1),
(7, 25.50, 'Overdue - 7 days', 0), (6, 0.00, 'N/A', 1),
(3, 0.00, 'N/A', 1), (4, 0.00, 'N/A', 1),
(5, 0.00, 'N/A', 1), (8, 0.00, 'N/A', 1),
(9, 0.00, 'N/A', 1), (10, 0.00, 'N/A', 1),
(11, 0.00, 'N/A', 1), (12, 0.00, 'N/A', 1),
(13, 10.00, 'Damaged cover', 0), (14, 0.00, 'N/A', 1),
(15, 0.00, 'N/A', 1), (16, 0.00, 'N/A', 1),
(17, 0.00, 'N/A', 1), (18, 15.00, 'Late return', 0),
(19, 0.00, 'N/A', 1), (20, 0.00, 'N/A', 1);

-- 10. POPULATE BOOKAUTHORS (N:M bridge — 20 Records)
-- Each book maps to its primary author, plus selected books have co-authors
INSERT INTO BookAuthors (BookID, AuthorID, Role) VALUES
( 1,  1, 'Primary'),    -- 1984 → Orwell
( 2,  2, 'Primary'),    -- Harry Potter → Rowling
( 3,  3, 'Primary'),    -- A Brief History of Time → Hawking
( 4,  4, 'Primary'),    -- Sapiens → Harari
( 5,  5, 'Primary'),    -- The Lord of the Rings → Tolkien
( 6,  6, 'Primary'),    -- Star Rail Chronicles → Murata
( 6,  7, 'Co-Author'),  -- Star Rail Chronicles → Yang (co-author)
( 7,  7, 'Primary'),    -- Void Archives → Yang
( 8,  8, 'Primary'),    -- Cloud Knight Records → Dan Heng
( 9,  9, 'Primary'),    -- Memories of Six Phases → March
( 9, 10, 'Co-Author'),  -- Memories of Six Phases → Stelle (co-author)
(10, 10, 'Primary'),    -- The Stellaron Crisis → Stelle
(11, 11, 'Primary'),    -- Foundation → Asimov
(12, 12, 'Primary'),    -- Murder on the Orient Express → Christie
(13, 13, 'Primary'),    -- The Old Man and the Sea → Hemingway
(14, 14, 'Primary'),    -- The Adventures of Tom Sawyer → Twain
(15, 15, 'Primary'),    -- Crime and Punishment → Dostoevsky
(16, 16, 'Primary'),    -- War and Peace → Tolstoy
(17, 17, 'Primary'),    -- Mrs Dalloway → Woolf
(18, 18, 'Primary'),    -- Ulysses → Joyce
(19, 19, 'Primary'),    -- One Hundred Years of Solitude → Garcia Marquez
(20, 20, 'Primary');    -- Kafka on the Shore → Murakami


SELECT 'Categories'   AS TableName, COUNT(*) AS RecordCount FROM Categories
UNION ALL
SELECT 'Authors',     COUNT(*) FROM Authors
UNION ALL
SELECT 'Books',       COUNT(*) FROM Books
UNION ALL
SELECT 'BookAuthors', COUNT(*) FROM BookAuthors
UNION ALL
SELECT 'Members',     COUNT(*) FROM Members
UNION ALL
SELECT 'Staff',       COUNT(*) FROM Staff
UNION ALL
SELECT 'Loans',       COUNT(*) FROM Loans
UNION ALL
SELECT 'Reservations',COUNT(*) FROM Reservations
UNION ALL
SELECT 'Fines',       COUNT(*) FROM Fines;

-- 10 SELECT QUERIES (Basic + Advanced)
-- 1. View all books published after 2000
SELECT Title, PublishYear, ISBN FROM Books WHERE PublishYear > 2000;
-- 2. Advanced LIKE search for "Star" in titles
SELECT * FROM Books WHERE Title LIKE '%Star%';
-- 3. Logical Operators: Active Student or Faculty members
SELECT FirstName, LastName, MembershipType FROM Members 
WHERE IsActive = 1 AND (MembershipType = 'Student' OR MembershipType = 'Faculty');
-- 4. Range filter for book stock levels
SELECT Title, TotalCopies FROM Books WHERE TotalCopies BETWEEN 5 AND 10;
-- 5. Null check for unreturned items
SELECT LoanID, BookID, MemberID FROM Loans WHERE ReturnDate IS NULL;
-- 6. Alphabetical sort of authors
SELECT LastName, FirstName, Nationality FROM Authors ORDER BY LastName ASC;
-- 7. Unique nationalities in the archive
SELECT DISTINCT Nationality FROM Authors;
-- 8. Top 5 most recently hired staff
SELECT TOP 5 FirstName, LastName, HireDate FROM Staff ORDER BY HireDate DESC;
-- 9. Members who joined in Q1 2025
SELECT FirstName, Email, JoinDate FROM Members 
WHERE JoinDate >= '2025-01-01' AND JoinDate <= '2025-03-31';
-- 10. Column Aliasing for formatted reporting
SELECT Title AS [Archive Item], TotalCopies AS [Stock Level] FROM Books;

-- 3 JOIN QUERIES
-- 1. Three-Table JOIN: Book Title, Author, and Category
SELECT B.Title, A.LastName AS Author, C.CategoryName
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Categories C ON B.CategoryID = C.CategoryID;
-- 2. Circulation Log: Linking Member, Book, and Staff
SELECT L.LoanID, M.FirstName + ' ' + M.LastName AS MemberName, B.Title, S.FirstName AS Librarian
FROM Loans L
JOIN Members M ON L.MemberID = M.MemberID
JOIN Books B ON L.BookID = B.BookID
JOIN Staff S ON L.StaffID = S.StaffID;
-- 3. Fine Reporting: Linking penalty details to members
SELECT M.LastName, B.Title, F.Amount, F.Reason
FROM Fines F
JOIN Loans L ON F.LoanID = L.LoanID
JOIN Members M ON L.MemberID = M.MemberID
JOIN Books B ON L.BookID = B.BookID
WHERE F.IsPaid = 0;
-- BONUS JOIN: Books with ALL their authors via BookAuthors (N:M relationship demo)
SELECT B.Title, A.FirstName + ' ' + A.LastName AS AuthorName, BA.Role
FROM BookAuthors BA
JOIN Books B    ON BA.BookID   = B.BookID
JOIN Authors A  ON BA.AuthorID = A.AuthorID
ORDER BY B.Title, BA.Role;

-- 2 AGGREGATE QUERIES (SUM, AVG, COUNT)
-- 1. Total books categorized per group
SELECT C.CategoryName, COUNT(B.BookID) AS BookCount
FROM Categories C
LEFT JOIN Books B ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName;
-- 2. Outstanding revenue calculation
SELECT SUM(Amount) AS TotalRevenueDue, AVG(Amount) AS AverageFine
FROM Fines WHERE IsPaid = 0;

-- 2 SUBQUERIES
-- 1. Members with overdue items via IN clause
SELECT FirstName, Email FROM Members 
WHERE MemberID IN (SELECT MemberID FROM Loans WHERE Status = 'Overdue');
-- 2. Categories with active inventory via EXISTS
SELECT CategoryName FROM Categories C
WHERE EXISTS (SELECT 1 FROM Books B WHERE B.CategoryID = C.CategoryID);

-- 2 UPDATE QUERIES
-- 1. Update member subscription expiry
UPDATE Members SET ExpiryDate = '2027-01-10' WHERE MemberID = 1;
-- 2. Record fine payment [cite: 57]
UPDATE Fines SET IsPaid = 1, PaidDate = GETDATE() WHERE FineID = 3;

-- 2 DELETE QUERIES
-- 1. Clean up cancelled hold requests
DELETE FROM Reservations WHERE Status = 'Cancelled';
-- 2. Remove inactive staff record [cite: 58]
DELETE FROM Staff WHERE StaffID = 20;