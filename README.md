<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Final Fantasy Lattice - README</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #0d1117;
            color: #c9d1d9;
            line-height: 1.6;
            padding: 20px;
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            padding: 30px 0;
            margin-bottom: 30px;
            border-bottom: 1px solid #30363d;
        }
        
        h1 {
            font-size: 2.5rem;
            color: #58a6ff;
            margin-bottom: 15px;
        }
        
        h2 {
            font-size: 1.8rem;
            color: #58a6ff;
            margin: 25px 0 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #30363d;
        }
        
        h3 {
            font-size: 1.4rem;
            color: #f78166;
            margin: 20px 0 10px;
        }
        
        p {
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin: 20px 0;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .badge-license {
            background-color: #3fb950;
            color: white;
        }
        
        .badge-version {
            background-color: #58a6ff;
            color: white;
        }
        
        .badge-status {
            background-color: #a371f7;
            color: white;
        }
        
        .badge-language {
            background-color: #e3b341;
            color: white;
        }
        
        .toc {
            background: linear-gradient(135deg, #161b22 0%, #1c2129 100%);
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
            border-left: 4px solid #58a6ff;
        }
        
        .toc-title {
            font-size: 1.3rem;
            margin-bottom: 15px;
            color: #f78166;
        }
        
        .toc ul {
            list-style-type: none;
        }
        
        .toc li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }
        
        .toc li:before {
            content: "•";
            position: absolute;
            left: 0;
            color: #58a6ff;
        }
        
        .toc a {
            color: #58a6ff;
            text-decoration: none;
        }
        
        .toc a:hover {
            text-decoration: underline;
        }
        
        .code-block {
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            padding: 16px;
            margin: 20px 0;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        
        .code-block code {
            color: #c9d1d9;
        }
        
        .command {
            color: #7ee787;
        }
        
        .comment {
            color: #8b949e;
        }
        
        .note {
            background: rgba(158, 158, 25, 0.1);
            border-left: 4px solid #e3b341;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        .warning {
            background: rgba(203, 36, 49, 0.1);
            border-left: 4px solid #f85149;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        .success {
            background: rgba(35, 134, 54, 0.1);
            border-left: 4px solid #3fb950;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        th, td {
            border: 1px solid #30363d;
            padding: 12px;
            text-align: left;
        }
        
        th {
            background-color: #161b22;
            color: #58a6ff;
        }
        
        tr:nth-child(even) {
            background-color: #151b24;
        }
        
        .contributors {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 20px 0;
        }
        
        .contributor {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(22, 27, 34, 0.7);
            padding: 10px;
            border-radius: 8px;
            width: calc(50% - 10px);
        }
        
        .contributor-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(45deg, #58a6ff, #a371f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .contributor-info {
            flex: 1;
        }
        
        .contributor-name {
            font-weight: 600;
            color: #58a6ff;
        }
        
        .contributor-role {
            font-size: 0.9rem;
            color: #8b949e;
        }
        
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #30363d;
            color: #8b949e;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            .contributor {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Final Fantasy Lattice</h1>
        <p>A comprehensive database of items from the Final Fantasy Lattice universe</p>
        
        <div class="badges">
            <span class="badge badge-license">MIT License</span>
            <span class="badge badge-version">Version 1.0.0</span>
            <span class="badge badge-status">Active Development</span>
            <span class="badge badge-language">HTML, CSS, JavaScript</span>
        </div>
    </div>
    
    <div class="toc">
        <div class="toc-title">Table of Contents</div>
        <ul>
            <li><a href="#overview">Overview</a></li>
            <li><a href="#features">Features</a></li>
            <li><a href="#installation">Installation</a></li>
            <li><a href="#usage">Usage</a></li>
            <li><a href="#item-categories">Item Categories</a></li>
            <li><a href="#contributing">Contributing</a></li>
            <li><a href="#contributors">Contributors</a></li>
            <li><a href="#license">License</a></li>
        </ul>
    </div>
    
    <section id="overview">
        <h2>Overview</h2>
        <p>Final Fantasy Lattice is a comprehensive database of items from the expansive Final Fantasy Lattice universe. This repository contains detailed information about weapons, armor, accessories, consumables, and key items that define the gameplay experience across multiple dimensions of the Lattice.</p>
        
        <p>The project aims to provide developers and fans with a structured, easily accessible resource for building applications, games, or websites related to the Final Fantasy Lattice universe.</p>
        
        <div class="note">
            <p><strong>Note:</strong> Final Fantasy Lattice is a fictional universe created by Srí Nathaniel Henry Fox. This repository is a fan-created resource.</p>
        </div>
    </section>
    
    <section id="features">
        <h2>Features</h2>
        <ul>
            <li>Comprehensive database of items from the Final Fantasy Lattice universe</li>
            <li>Well-structured data in JSON format for easy integration</li>
            <li>Search functionality to quickly find specific items</li>
            <li>Responsive design that works on desktop and mobile devices</li>
            <li>Detailed item information including stats, descriptions, and locations</li>
            <li>Regular updates with new items and categories</li>
        </ul>
    </section>
    
    <section id="installation">
        <h2>Installation</h2>
        <p>To use the Final Fantasy Lattice item database, you can clone this repository or download the files directly.</p>
        
        <div class="code-block">
            <code>
                <span class="comment"># Clone the repository</span><br>
                <span class="command">git clone https://github.com/DeepGreenAntennas/final-fantasy-lattice-items.git</span><br>
                <br>
                <span class="comment"># Navigate to the project directory</span><br>
                <span class="command">cd final-fantasy-lattice-items</span><br>
                <br>
                <span class="comment"># Install dependencies (if any)</span><br>
                <span class="command">npm install</span>
            </code>
        </div>
        
        <p>Alternatively, you can include the item data directly in your project by copying the JSON files from the <code>data</code> directory.</p>
    </section>
    
    <section id="usage">
        <h2>Usage</h2>
        <p>The item data is stored in JSON format for easy integration into your projects. Here's an example of how to use the data:</p>
        
        <div class="code-block">
            <code>
                <span class="comment">// Example: Loading weapon data</span><br>
                fetch('./data/weapons.json')<br>
                &nbsp;&nbsp;.then(response => response.json())<br>
                &nbsp;&nbsp;.then(data => {<br>
                &nbsp;&nbsp;&nbsp;&nbsp;console.log(data);<br>
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="comment">// Process the weapon data</span><br>
                &nbsp;&nbsp;})<br>
                &nbsp;&nbsp;.catch(error => console.error('Error loading data:', error));
            </code>
        </div>
        
        <p>Each item in the database has the following structure:</p>
        
        <div class="code-block">
            <code>
                {<br>
                &nbsp;&nbsp;"id": "ultima-blade",<br>
                &nbsp;&nbsp;"name": "Ultima Blade",<br>
                &nbsp;&nbsp;"type": "Sword",<br>
                &nbsp;&nbsp;"category": "Weapons",<br>
                &nbsp;&nbsp;"description": "A legendary sword forged from crystallized Lattice energy.",<br>
                &nbsp;&nbsp;"stats": {<br>
                &nbsp;&nbsp;&nbsp;&nbsp;"attack": 98,<br>
                &nbsp;&nbsp;&nbsp;&nbsp;"magic_attack": 45,<br>
                &nbsp;&nbsp;&nbsp;&nbsp;"special": "Increases damage with each consecutive hit"<br>
                &nbsp;&nbsp;},<br>
                &nbsp;&nbsp;"location": "Forged from materials found in the Crystal Tower",<br>
                &nbsp;&nbsp;"value": 12500<br>
                }
            </code>
        </div>
    </section>
    
    <section id="item-categories">
        <h2>Item Categories</h2>
        <p>The items are organized into the following categories:</p>
        
        <table>
            <thead>
                <tr>
                    <th>Category</th>
                    <th>Description</th>
                    <th>Number of Items</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Weapons</td>
                    <td>Swords, staffs, bows, and other offensive equipment</td>
                    <td>42</td>
                </tr>
                <tr>
                    <td>Armor</td>
                    <td>Protective gear including shields, helmets, and body armor</td>
                    <td>38</td>
                </tr>
                <tr>
                    <td>Accessories</td>
                    <td>Items that provide special abilities and stat boosts</td>
                    <td>25</td>
                </tr>
                <tr>
                    <td>Consumables</td>
                    <td>Potions, ethers, and other single-use items</td>
                    <td>30</td>
                </tr>
                <tr>
                    <td>Key Items</td>
                    <td>Plot-essential items that advance the game's story</td>
                    <td>18</td>
                </tr>
            </tbody>
        </table>
    </section>
    
    <section id="contributing">
        <h2>Contributing</h2>
        <p>We welcome contributions to the Final Fantasy Lattice item database! To contribute:</p>
        
        <ol>
            <li>Fork the repository</li>
            <li>Create a new branch for your changes</li>
            <li>Add your item data following the existing JSON structure</li>
            <li>Test your changes to ensure they work correctly</li>
            <li>Submit a pull request with a description of your changes</li>
        </ol>
        
        <div class="warning">
            <p><strong>Please note:</strong> All contributions must be original content. Do not submit copyrighted material from official Final Fantasy games.</p>
        </div>
        
        <p>For major changes, please open an issue first to discuss what you would like to change.</p>
    </section>
    
    <section id="contributors">
        <h2>Contributors</h2>
        <p>Thanks to these amazing people who have contributed to this project:</p>
        
        <div class="contributors">
            <div class="contributor">
                <div class="contributor-avatar">SN</div>
                <div class="contributor-info">
                    <div class="contributor-name">Srí Nathaniel Henry Fox</div>
                    <div class="contributor-role">Project Creator</div>
                </div>
            </div>
            
            <div class="contributor">
                <div class="contributor-avatar">ML</div>
                <div class="contributor-info">
                    <div class="contributor-name">Morgan Lattice</div>
                    <div class="contributor-role">Data Curator</div>
                </div>
            </div>
            
            <div class="contributor">
                <div class="contributor-avatar">AC</div>
                <div class="contributor-info">
                    <div class="contributor-name">Alex Crystal</div>
                    <div class="contributor-role">UI Developer</div>
                </div>
            </div>
            
            <div class="contributor">
                <div class="contributor-avatar">RF</div>
                <div class="contributor-info">
                    <div class="contributor-name">Ryu Fujibayashi</div>
                    <div class="contributor-role">Lore Specialist</div>
                </div>
            </div>
        </div>
    </section>
    
    <section id="license">
        <h2>License</h2>
        <p>This project is licensed under the MIT License - see the <a href="#">LICENSE.md</a> file for details.</p>
        
        <div class="note">
            <p><strong>Disclaimer:</strong> Final Fantasy Lattice is a fan-created project. Final Fantasy is a registered trademark of Square Enix. This project is not officially affiliated with or endorsed by Square Enix.</p>
        </div>
    </section>
    
    <div class="footer">
        <p>© 2023 Final Fantasy Lattice Project. Created by Srí Nathaniel Henry Fox.</p>
        <p>This README was generated on: October 15, 2023</p>
    </div>
</body>
</html>
