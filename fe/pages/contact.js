import React from 'react';

const contactPoints = [
  {
    id: 'hq',
    name: 'Rainbow Toddler HQ',
    type: 'Head Office',
    address: '289 Nguyen Van Cu, District 5, Ho Chi Minh City',
    phone: '+84 28 7300 7788',
    email: 'hello@rainbowtoddler.vn',
    hours: 'Mon - Fri: 08:30 - 18:00',
    image:
      'https://images.unsplash.com/photo-1497215842964-222b430dc094?auto=format&fit=crop&w=1200&q=80',
  },
  {
    id: 'showroom',
    name: 'Family Experience Showroom',
    type: 'Flagship Store',
    address: '102 Le Loi, District 1, Ho Chi Minh City',
    phone: '+84 28 7300 1199',
    email: 'store@rainbowtoddler.vn',
    hours: 'Daily: 09:00 - 21:30',
    image:
      'https://images.unsplash.com/photo-1555529902-5261145633bf?auto=format&fit=crop&w=1200&q=80',
  },
  {
    id: 'care',
    name: 'Customer Care Center',
    type: 'Support Team',
    address: 'Hotline and Online Support',
    phone: '1900 8899',
    email: 'support@rainbowtoddler.vn',
    hours: 'Daily: 08:00 - 22:00',
    image:
      'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1200&q=80',
  },
];

const supportTeam = [
  {
    name: 'Linh Tran',
    role: 'Parenting Product Specialist',
    bio: 'Helping families choose toys by age and development stage.',
    avatar:
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=600&q=80',
  },
  {
    name: 'Minh Pham',
    role: 'After-Sales Support Lead',
    bio: 'Fast support for warranty, exchange, and order updates.',
    avatar:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
  },
  {
    name: 'An Vo',
    role: 'STEM Toys Consultant',
    bio: 'Consulting kits that build creativity and problem-solving skills.',
    avatar:
      'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=600&q=80',
  },
];

const quickFaq = [
  {
    q: 'How fast do you respond?',
    a: 'Live chat usually replies within 5-10 minutes during support hours.',
  },
  {
    q: 'Can I change my order after checkout?',
    a: 'Yes, contact us within 60 minutes so we can update your order before shipping.',
  },
  {
    q: 'Do you support gift wrapping?',
    a: 'Yes, we offer free gift notes and premium wrapping for selected events.',
  },
];

export default function ContactPage() {
  return (
    <div className="contact-page">
      <section className="hero">
        <div className="hero-overlay" />
        <div className="hero-content">
          <p className="hero-kicker">Contact Rainbow Toddler</p>
          <h1>We are here for every parent question</h1>
          <p>
            Need help choosing toys, tracking an order, or finding the right gift? Our team is available via
            phone, email, and in-store support.
          </p>
          <div className="hero-actions">
            <a href="tel:19008899" className="hero-btn primary">
              Call 1900 8899
            </a>
            <a href="mailto:support@rainbowtoddler.vn" className="hero-btn ghost">
              Email Support
            </a>
          </div>
        </div>
      </section>

      <section className="stats-wrap">
        <article className="stat-card">
          <div className="stat-value">7/7</div>
          <div className="stat-label">Support Availability</div>
        </article>
        <article className="stat-card">
          <div className="stat-value">5 min</div>
          <div className="stat-label">Average Chat Reply</div>
        </article>
        <article className="stat-card">
          <div className="stat-value">30k+</div>
          <div className="stat-label">Families Supported</div>
        </article>
        <article className="stat-card">
          <div className="stat-value">98%</div>
          <div className="stat-label">Satisfaction Score</div>
        </article>
      </section>

      <section className="section shell">
        <header className="section-head">
          <h2>Our locations and channels</h2>
          <p>Choose the contact point that works best for you.</p>
        </header>
        <div className="locations-grid">
          {contactPoints.map((point) => (
            <article className="location-card" key={point.id}>
              <div className="location-cover" style={{ backgroundImage: `url(${point.image})` }} />
              <div className="location-body">
                <div className="location-type">{point.type}</div>
                <h3>{point.name}</h3>
                <ul>
                  <li>
                    <strong>Address:</strong> {point.address}
                  </li>
                  <li>
                    <strong>Phone:</strong> {point.phone}
                  </li>
                  <li>
                    <strong>Email:</strong> {point.email}
                  </li>
                  <li>
                    <strong>Hours:</strong> {point.hours}
                  </li>
                </ul>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section className="section shell support-layout">
        <div className="support-panel">
          <header className="section-head left">
            <h2>Meet our support team</h2>
            <p>Real people who understand toys, safety, and child development.</p>
          </header>

          <div className="team-grid">
            {supportTeam.map((member) => (
              <article className="team-card" key={member.name}>
                <img src={member.avatar} alt={member.name} loading="lazy" />
                <div className="team-content">
                  <h3>{member.name}</h3>
                  <p className="role">{member.role}</p>
                  <p>{member.bio}</p>
                </div>
              </article>
            ))}
          </div>
        </div>

        <aside className="faq-panel">
          <h3>Quick FAQ</h3>
          {quickFaq.map((item) => (
            <div className="faq-item" key={item.q}>
              <h4>{item.q}</h4>
              <p>{item.a}</p>
            </div>
          ))}
        </aside>
      </section>

      <section className="section shell contact-form-wrap">
        <div className="form-intro">
          <h2>Send us a message</h2>
          <p>
            Leave your details and question. We will get back to you by phone or email as soon as possible.
          </p>
        </div>
        <form className="contact-form" onSubmit={(e) => e.preventDefault()}>
          <label>
            Full name
            <input type="text" placeholder="Enter your name" />
          </label>
          <label>
            Email
            <input type="email" placeholder="you@example.com" />
          </label>
          <label>
            Phone number
            <input type="tel" placeholder="09xx xxx xxx" />
          </label>
          <label>
            Topic
            <select defaultValue="">
              <option value="" disabled>
                Select a topic
              </option>
              <option value="order">Order support</option>
              <option value="product">Product advice</option>
              <option value="warranty">Warranty and exchange</option>
              <option value="other">Other</option>
            </select>
          </label>
          <label className="full-row">
            Message
            <textarea rows="5" placeholder="How can we help you today?" />
          </label>
          <button type="submit">Send Message</button>
        </form>
      </section>

      <style jsx>{`
        .contact-page {
          background: linear-gradient(180deg, #f3f8fb 0%, #ffffff 26%, #ffffff 100%);
          color: #1d2b36;
        }

        .shell {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 20px;
        }

        .hero {
          position: relative;
          min-height: 500px;
          background-image: url('https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=2000&q=80');
          background-size: cover;
          background-position: center;
          border-bottom-left-radius: 28px;
          border-bottom-right-radius: 28px;
          overflow: hidden;
          display: flex;
          align-items: center;
          margin: 0 14px;
        }

        .hero-overlay {
          position: absolute;
          inset: 0;
          background: linear-gradient(105deg, rgba(16, 29, 40, 0.88) 0%, rgba(16, 29, 40, 0.52) 48%, rgba(16, 29, 40, 0.28) 100%);
        }

        .hero-content {
          position: relative;
          z-index: 1;
          max-width: 700px;
          padding: 70px 40px;
          color: #ffffff;
        }

        .hero-kicker {
          display: inline-block;
          padding: 8px 14px;
          border-radius: 999px;
          background: rgba(28, 168, 200, 0.3);
          border: 1px solid rgba(255, 255, 255, 0.25);
          font-size: 13px;
          font-weight: 700;
          letter-spacing: 0.2px;
          margin-bottom: 14px;
        }

        .hero h1 {
          font-size: clamp(34px, 6vw, 58px);
          line-height: 1.06;
          margin: 0 0 16px;
          font-weight: 800;
        }

        .hero p {
          font-size: 17px;
          line-height: 1.65;
          max-width: 620px;
          color: #ebf7ff;
        }

        .hero-actions {
          margin-top: 24px;
          display: flex;
          gap: 12px;
          flex-wrap: wrap;
        }

        .hero-btn {
          border-radius: 12px;
          padding: 12px 18px;
          font-weight: 700;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .hero-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 10px 24px rgba(0, 0, 0, 0.22);
        }

        .hero-btn.primary {
          background: #1ca8c8;
          color: #ffffff;
        }

        .hero-btn.ghost {
          background: rgba(255, 255, 255, 0.15);
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.35);
        }

        .stats-wrap {
          max-width: 1200px;
          margin: -46px auto 0;
          padding: 0 20px;
          display: grid;
          grid-template-columns: repeat(4, minmax(0, 1fr));
          gap: 14px;
          position: relative;
          z-index: 2;
        }

        .stat-card {
          background: #ffffff;
          border: 1px solid #e2edf3;
          border-radius: 16px;
          padding: 20px 16px;
          text-align: center;
          box-shadow: 0 12px 22px rgba(15, 42, 58, 0.08);
        }

        .stat-value {
          color: #106b85;
          font-size: clamp(24px, 3vw, 34px);
          font-weight: 800;
          line-height: 1.1;
        }

        .stat-label {
          margin-top: 7px;
          font-size: 13px;
          color: #4d6573;
          font-weight: 600;
        }

        .section {
          padding: 64px 0 18px;
        }

        .section-head {
          text-align: center;
          margin-bottom: 26px;
        }

        .section-head.left {
          text-align: left;
        }

        .section-head h2 {
          margin: 0;
          font-size: clamp(28px, 4vw, 40px);
          color: #113143;
          line-height: 1.14;
        }

        .section-head p {
          margin-top: 10px;
          color: #516a78;
          font-size: 16px;
        }

        .locations-grid {
          display: grid;
          grid-template-columns: repeat(3, minmax(0, 1fr));
          gap: 18px;
        }

        .location-card {
          border-radius: 18px;
          overflow: hidden;
          background: #ffffff;
          border: 1px solid #e0ebf1;
          box-shadow: 0 12px 24px rgba(20, 53, 69, 0.08);
          transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .location-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 18px 28px rgba(20, 53, 69, 0.13);
        }

        .location-cover {
          height: 180px;
          background-size: cover;
          background-position: center;
        }

        .location-body {
          padding: 16px;
        }

        .location-type {
          display: inline-block;
          font-size: 12px;
          font-weight: 800;
          letter-spacing: 0.4px;
          color: #0f7a97;
          background: #e6f6fa;
          padding: 6px 10px;
          border-radius: 999px;
          margin-bottom: 10px;
          text-transform: uppercase;
        }

        .location-body h3 {
          margin: 0 0 10px;
          color: #173a4c;
          font-size: 20px;
          line-height: 1.25;
        }

        .location-body ul {
          list-style: none;
          margin: 0;
          padding: 0;
          display: grid;
          gap: 8px;
          color: #3f5968;
          font-size: 14px;
          line-height: 1.5;
        }

        .support-layout {
          display: grid;
          grid-template-columns: minmax(0, 2fr) minmax(0, 1fr);
          gap: 18px;
          align-items: start;
        }

        .support-panel,
        .faq-panel {
          background: #ffffff;
          border: 1px solid #e1edf4;
          border-radius: 18px;
          padding: 24px;
          box-shadow: 0 10px 20px rgba(15, 42, 58, 0.06);
        }

        .team-grid {
          margin-top: 16px;
          display: grid;
          grid-template-columns: repeat(3, minmax(0, 1fr));
          gap: 14px;
        }

        .team-card {
          background: #f8fcfe;
          border: 1px solid #e2eef3;
          border-radius: 14px;
          overflow: hidden;
        }

        .team-card img {
          width: 100%;
          height: 190px;
          object-fit: cover;
          display: block;
        }

        .team-content {
          padding: 12px;
        }

        .team-content h3 {
          margin: 0;
          font-size: 19px;
          color: #173a4c;
        }

        .team-content .role {
          margin: 5px 0 7px;
          color: #0f7a97;
          font-weight: 700;
          font-size: 13px;
        }

        .team-content p {
          margin: 0;
          font-size: 13px;
          color: #526d7c;
          line-height: 1.5;
        }

        .faq-panel h3 {
          margin: 0 0 14px;
          font-size: 26px;
          color: #12384a;
        }

        .faq-item + .faq-item {
          margin-top: 12px;
          padding-top: 12px;
          border-top: 1px solid #e3eef4;
        }

        .faq-item h4 {
          margin: 0;
          color: #194156;
          font-size: 16px;
        }

        .faq-item p {
          margin: 6px 0 0;
          color: #4f6978;
          line-height: 1.6;
          font-size: 14px;
        }

        .contact-form-wrap {
          padding-bottom: 70px;
        }

        .form-intro {
          margin-bottom: 14px;
        }

        .form-intro h2 {
          margin: 0;
          font-size: clamp(28px, 4vw, 40px);
          color: #113143;
        }

        .form-intro p {
          margin-top: 10px;
          color: #4f6877;
          font-size: 16px;
          max-width: 760px;
          line-height: 1.6;
        }

        .contact-form {
          margin-top: 16px;
          background: #ffffff;
          border: 1px solid #e1edf4;
          border-radius: 18px;
          padding: 24px;
          box-shadow: 0 10px 20px rgba(15, 42, 58, 0.06);
          display: grid;
          grid-template-columns: repeat(2, minmax(0, 1fr));
          gap: 14px;
        }

        .contact-form label {
          display: grid;
          gap: 8px;
          font-size: 13px;
          font-weight: 700;
          color: #2b4b5d;
        }

        .contact-form label.full-row {
          grid-column: 1 / -1;
        }

        .contact-form input,
        .contact-form select,
        .contact-form textarea {
          border: 1px solid #cfe1eb;
          border-radius: 12px;
          padding: 11px 12px;
          font-size: 14px;
          color: #19394a;
          background: #fbfeff;
          outline: none;
          transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .contact-form input:focus,
        .contact-form select:focus,
        .contact-form textarea:focus {
          border-color: #1ca8c8;
          box-shadow: 0 0 0 4px rgba(28, 168, 200, 0.15);
        }

        .contact-form button {
          grid-column: 1 / -1;
          border: 0;
          background: linear-gradient(135deg, #1ca8c8 0%, #1591af 100%);
          color: #ffffff;
          font-weight: 800;
          border-radius: 12px;
          padding: 13px;
          cursor: pointer;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .contact-form button:hover {
          transform: translateY(-2px);
          box-shadow: 0 12px 20px rgba(21, 145, 175, 0.3);
        }

        @media (max-width: 1100px) {
          .locations-grid {
            grid-template-columns: 1fr 1fr;
          }

          .support-layout {
            grid-template-columns: 1fr;
          }

          .team-grid {
            grid-template-columns: 1fr 1fr;
          }

          .stats-wrap {
            grid-template-columns: 1fr 1fr;
          }
        }

        @media (max-width: 720px) {
          .hero {
            margin: 0;
            border-radius: 0;
            min-height: 460px;
          }

          .hero-content {
            padding: 70px 20px;
          }

          .locations-grid,
          .team-grid,
          .contact-form {
            grid-template-columns: 1fr;
          }

          .stats-wrap {
            margin-top: -22px;
            grid-template-columns: 1fr;
          }

          .section {
            padding-top: 48px;
          }
        }
      `}</style>
    </div>
  );
}
