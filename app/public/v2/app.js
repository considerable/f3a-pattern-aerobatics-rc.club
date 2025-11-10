// F3A Microservice Frontend JavaScript

class F3AApp {
    constructor() {
        this.apiBase = 'http://app.f3a-pattern-aerobatics-rc.club:30080';
        this.init();
    }

    async init() {
        await this.checkHealth();
        await this.loadClubInfo();
        await this.loadEvents();
        await this.loadAircraft();
        await this.loadBrands();
        this.setupNavigation();

        // Periodic health check
        setInterval(() => this.checkHealth(), 30000);
    }

    async checkHealth() {
        const indicator = document.getElementById('health-indicator');
        const text = document.getElementById('health-text');

        try {
            indicator.className = 'checking';
            text.textContent = 'Checking...';

            const response = await fetch(`${this.apiBase}/health`);
            const data = await response.json();

            if (response.ok && data.status === 'healthy') {
                indicator.className = 'healthy';
                text.textContent = `Service healthy (${data.version})`;
            } else {
                throw new Error('Unhealthy response');
            }
        } catch (error) {
            indicator.className = 'unhealthy';
            text.textContent = 'Service unavailable';
            console.error('Health check failed:', error);
        }
    }

    async loadClubInfo() {
        const container = document.getElementById('club-info');

        try {
            const response = await fetch(`${this.apiBase}/api/club`);
            const club = await response.json();

            container.innerHTML = `
                <div class="card">
                    <h3>${club.name}</h3>
                    <p><strong>Description:</strong> ${club.description}</p>
                    <p><strong>Location:</strong> ${club.location}</p>
                    <p><strong>Founded:</strong> ${club.founded}</p>

                    <h4>Activities:</h4>
                    <ul>
                        ${club.activities.map(activity => `<li>${activity}</li>`).join('')}
                    </ul>

                    <div style="margin-top: 1rem;">
                        <p><strong>Email:</strong> ${club.contact.email}</p>
                        <p><strong>Meetings:</strong> ${club.contact.meetings}</p>
                    </div>
                </div>
            `;
        } catch (error) {
            container.innerHTML = '<div class="card">Failed to load club information.</div>';
            console.error('Failed to load club info:', error);
        }
    }

    async loadEvents() {
        const container = document.getElementById('events-list');

        try {
            const response = await fetch(`${this.apiBase}/api/events`);
            const data = await response.json();

            container.innerHTML = data.upcoming.map(event => `
                <div class="card event-card">
                    <h3>${event.title}</h3>
                    <p class="event-date">${this.formatDate(event.date)} at ${event.time}</p>
                    <p><strong>Location:</strong> ${event.location}</p>
                    <p>${event.description}</p>
                </div>
            `).join('');
        } catch (error) {
            container.innerHTML = '<div class="card">Failed to load events.</div>';
            console.error('Failed to load events:', error);
        }
    }

    async loadAircraft() {
        const container = document.getElementById('aircraft-list');

        try {
            const response = await fetch(`${this.apiBase}/api/aircraft`);
            const data = await response.json();

            container.innerHTML = data.recommended.map(aircraft => `
                <div class="card aircraft-card">
                    <h3>${aircraft.name}</h3>
                    <div class="aircraft-specs">
                        <div class="spec">
                            <strong>Wingspan</strong><br>
                            ${aircraft.wingspan}
                        </div>
                        <div class="spec">
                            <strong>Weight</strong><br>
                            ${aircraft.weight}
                        </div>
                        <div class="spec">
                            <strong>Engine</strong><br>
                            ${aircraft.engine}
                        </div>
                        <div class="spec">
                            <strong>Skill Level</strong><br>
                            ${aircraft.skill_level}
                        </div>
                    </div>
                </div>
            `).join('');
        } catch (error) {
            container.innerHTML = '<div class="card">Failed to load aircraft information.</div>';
            console.error('Failed to load aircraft:', error);
        }
    }

    async loadBrands() {
        const container = document.getElementById('brands-list');

        try {
            const response = await fetch(`${this.apiBase}/api/brands`);
            const data = await response.json();

            container.innerHTML = data.brands.map(brand => `
                <div class="card brand-card">
                    <h3>${brand.name}</h3>
                    <p><strong>Country:</strong> ${brand.country}</p>
                    <p><strong>Specialty:</strong> ${brand.specialty}</p>
                    <a href="${brand.website}" target="_blank">Visit Website</a>
                </div>
            `).join('');
        } catch (error) {
            container.innerHTML = '<div class="card">Backend API unavailable. Please start the microservice.</div>';
            console.error('Failed to load brands from API:', error);
        }
    }

    setupNavigation() {
        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    formatDate(dateString) {
        const options = {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        };
        return new Date(dateString).toLocaleDateString('en-US', options);
    }
}

// Global function for button click
function loadClubInfo() {
    document.getElementById('about').scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new F3AApp();
});
