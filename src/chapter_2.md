# Chapter 2: RC club website

A simple website to let the world know about your club

## 2.0.1 Static website design

A minimum viable F3A Pattern Aerobatics RC club website should have the following sections:

1. Home Page:
   - Welcome message and introduction to the club.
   - Brief overview of F3A Pattern Aerobatics and its significance.
   - Featured upcoming events or competitions.
   - Call-to-action buttons for joining the club or registering for events.

2. About Us:
   - Detailed information about the club's history and mission.
   - Introduction to the club's leadership and key members.
   - Club affiliations and partnerships with national organizations like NSRCA or AMA.

3. Events:
   - Calendar of upcoming F3A Pattern Aerobatics events and competitions.
   - Information about past events, including results and photos.
   - Registration process and links to register for upcoming events.

4. Rules and Guidelines:
   - Detailed explanations of the rules and regulations governing F3A Pattern Aerobatics.
   - Guidelines for pilots, judges, and spectators to ensure safe and fair competitions.
   - Links to official FAI or NSRCA rulebooks for reference.

5. Resources:
   - Educational materials and tutorials for pilots, especially newcomers to F3A.
   - Recommended airplane models and equipment for F3A Pattern Aerobatics.
   - Links to helpful websites and forums related to aeromodeling and precision aerobatics.

6. Club Membership:
   - Information on how to become a member of the F3A Pattern Aerobatics RC Club.
   - Benefits of membership, such as access to club facilities or discounts on events.
   - Membership fees and the process for joining or renewing membership.

7. Contact Us:
   - Contact details of the club's leadership or designated representatives.
   - A contact form for general inquiries or feedback from visitors.
   - Social media links for further engagement.

Please note that this is just a basic sample, and a fully functional website would require additional design, content, and functionality. The design can be enhanced with appealing graphics, responsive layout for mobile devices, and interactive features to engage visitors.


## 2.0.2 Jekyll project structure

To generate a static website using [Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll) for the F3A Pattern Aerobatics RC Club, you'll need to create a Jekyll project and organize your content accordingly. Below is an example folder structure to implement the above design:

```vbnet
f3a-pattern-aerobatics-rc-club/
├── _config.yml
├── _data
│   ├── events.yml
│   └── members.yml
├── _layouts
│   ├── default.html
│   └── home.html
├── _posts
│   ├── 2023-07-01-welcome-to-f3a.md
│   └── 2023-07-05-upcoming-event.md
├── _sass
│   └── style.scss
├── css
│   └── main.css
├── images
│   └── logo.png
├── index.html
├── about.html
├── events.html
├── rules.html
├── resources.html
├── membership.html
└── contact.html
```

## 2.0.3 GitHub Pages hosting

There are may optiong for webhosting. Hosting your static website on GitHub Pages offers several advantages:

1. Free Hosting:
   - GitHub Pages provides free hosting for static websites, making it an economical choice for individuals, small projects, or open-source initiatives without the need for additional hosting expenses.

2. Version Control Integration:
   - GitHub Pages is closely integrated with Git version control. You can easily update and manage your website by pushing changes to the repository, ensuring version history and easy collaboration with others.

3. Easy Setup:
   - Setting up a website on GitHub Pages is straightforward. You only need to create a new repository or use an existing one, and your website will be live at **username.github.io** or **username.github.io/repository-name**.

4. Continuous Deployment:
   - When you push changes to your repository, GitHub Pages will automatically rebuild and update your website, providing seamless continuous deployment.

5. Custom Domain Support:
   - GitHub Pages allows you to use a custom domain for your website, giving your project a more professional and branded appearance.

6. High Reliability and Security:
   - GitHub's infrastructure ensures high reliability and security for your website. GitHub takes care of server maintenance, security updates, and DDoS protection, so you can focus on your website's content and development.

7. No Server-Side Logic Required:
   - GitHub Pages is designed for static websites, so if your site doesn't require server-side logic or databases, it's an efficient solution.

8. Wide Adoption and Community:
   - GitHub Pages is widely used, and there is an active community of developers using and contributing to the platform. This means you can find plenty of resources, tutorials, and support to enhance your website.

9. Integration with Jekyll:
   - If you use Jekyll, a popular static site generator, GitHub Pages has built-in support for it, allowing you to leverage Jekyll's features like templating and content organization.

10. Project Documentation:
    - GitHub Pages is an excellent platform for hosting project documentation alongside your code repository, ensuring your users can easily access and understand your project.

Overall, GitHub Pages is a powerful and user-friendly option for hosting static websites, making it a preferred choice for many developers and projects, especially those closely tied to the GitHub ecosystem.
