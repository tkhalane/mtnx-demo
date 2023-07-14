// IF YOU ARE WORKING LOCALLY, YOU CAN USE SMEE.IO TO FORWARD THE WEBHOOK TO YOUR LOCALHOST
// YOU CAN GENERATE A SMEE URL BY GOING TO smee.getport.io
// 
// RUNNING A SMEE CLIENT IN YOUR CLI:
// smee --url YOUR_SMEE_URL_HERE --target http://127.0.0.1:8000/

import { createHmac } from 'crypto';
import express from 'express';
import axios from 'axios';
import bodyParser from 'body-parser';

const CLIENT_ID = "60EsooJtOqimlekxrNh7nfr2iOgTcyLZ";
const CLIENT_SECRET = "LG0KPxqje6ergzTbnSOBBGkwIdlc2o3r";

const API_URL = "https://backend.demo.getport.io/v1";

const app = express();
const port = 8000;

app.use(bodyParser.json());

app.post('/', async (request, response) => {
	// WEBHOOK SIGNATURE VALIDATION
	const signed = createHmac('sha256', CLIENT_SECRET)
	.update(`${request.headers['x-port-timestamp']}.${JSON.stringify(request.body)}`)
	.digest('base64');
	
	if (signed !== request.headers['x-port-signature'].split(',')[1]) {
		throw new Error('Invalid signature');
	}
	// WEBHOOK SIGNATURE VALIDATION

	/* You can put any custom logic here */

	try {
		// fetching the token
		const tokenResponse = await axios.post(`${API_URL}/auth/access_token`, {
			clientId: CLIENT_ID,
			clientSecret: CLIENT_SECRET,
		});
	  
		  const accessToken = tokenResponse.data.accessToken;
	
		  const config = {
			headers: {
			  Authorization: `Bearer ${accessToken}`,
			},
		  };
	
		const { runId, entity: entityId, blueprint: blueprintId } = request.body.context;

		
		// CREATE entity
		const createEntityEndpoint = `${API_URL}/blueprints/${blueprintId}/entities?create_missing_related_entities=true&run_id=${runId}`;
		await axios.post(
			createEntityEndpoint, 
			{"identifier":"80ea7c31-c54f-4dac-a864-f8122f2953c3","title":"Some Title","properties":{"service":"EC2","url":"https://example.com","tags":{"a":1,"b":2},"storesPII":false,"IaCCode":"string","IaC":"Pulumi"},"relations":{"cloud-account":"related_entity_identifier"}}, 
			config);
		
		console.log('Successfully created the entity');

		const insertLogsEndpoint = `${API_URL}/actions/runs/${runId}/logs`;
		const updateRunEndpoint = `${API_URL}/actions/runs/${runId}`;
	
		// create a log in the run
		await axios.post(insertLogsEndpoint, {
			message: 'Run completed successfully',
		}, config);
		console.log('Successfully created a log in the run');
		
		// update the status of the run
		await axios.patch(updateRunEndpoint, {
			status: 'SUCCESS',
		}, config);
		console.log('Successfully updated the run status');

	  } catch (error) {
		throw new Error('something went wrong: ', error.message);
	  }
});

app.listen(port, () => {
	console.log(`Example app listening on port ${port}`);
});
